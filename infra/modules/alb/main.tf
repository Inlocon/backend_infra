############################################
# Security Group (public 80/443 in)
############################################
resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-sg"
  description = "ALB SG (${var.name})"
  vpc_id      = var.vpc_id

  # Inbound 80 and 443 from Internet
  ingress { from_port = 80  to_port = 80  protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  ingress { from_port = 443 to_port = 443 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }

  # Egress anywhere (targets are in VPC)
  egress  { from_port = 0   to_port = 0   protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }

  tags = merge({ Name = "${var.name}-alb-sg" }, var.tags)
}

############################################
# Load Balancer
############################################
resource "aws_lb" "this" {
  name               = "${var.name}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.subnet_ids
  idle_timeout       = var.idle_timeout_seconds

  tags = merge({ Name = "${var.name}-alb" }, var.tags)
}

############################################
# Target Group (IP targets for Fargate)
############################################
resource "aws_lb_target_group" "app" {
  name        = "${var.name}-tg"
  vpc_id      = var.vpc_id
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = "ip"

  health_check {
    enabled             = true
    path                = var.health_check_path
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
    matcher             = "200-399"
  }

  tags = merge({ Name = "${var.name}-tg" }, var.tags)
}

############################################
# Listeners
############################################

# Optional HTTP → HTTPS redirect
resource "aws_lb_listener" "http" {
  count             = var.enable_http_redirect ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS listener → forward to target group
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
