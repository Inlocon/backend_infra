output "alb_arn" {
  description = "ALB ARN"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "Public DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "alb_sg_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "target_group_arn" {
  description = "Target group ARN (attach ECS service to this)"
  value       = aws_lb_target_group.app.arn
}

output "https_listener_arn" {
  description = "HTTPS listener ARN (null if not created)"
  value       = try(aws_lb_listener.https[0].arn, null)
}

output "http_listener_arn" {
  description = "HTTP listener ARN"
  value       = aws_lb_listener.http.arn
}
