locals {
  tags = { resourceGroup = "alb"}
}

############################################
# Security Group (public 80/443 in)
############################################
resource "aws_security_group" "alb" {
  name        = "${var.env}-alb-sg"
  description = "ALB SG (${var.env})"
  vpc_id      = var.vpc_id

  # Inbound 80 and 443 from Internet
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  # just keep egress default all
  tags = local.tags
}

############################################
# Load Balancer
############################################
resource "aws_lb" "this" {
  name               = "${var.env}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.subnet_ids
  idle_timeout       = var.idle_timeout_seconds

  tags = local.tags
}

############################################
# Target Group (IP targets for Fargate)
############################################
resource "aws_lb_target_group" "app" {
  name        = "${var.env}-tg"
  vpc_id      = var.vpc_id
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    matcher             = "200-399"
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = local.tags
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

  tags = local.tags
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

  tags = local.tags
}
