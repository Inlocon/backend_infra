variable "env" {
  description = "Environment name (test/prod)."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB lives"
  type        = string
}

variable "subnet_ids" {
  description = "List of public subnet IDs for the ALB. ALBs require at least two subnets in different AZs."
  type = list(string)
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS (in same region)"
  type        = string
}

variable "target_group_port" {
  description = "Port your ECS service exposes"
  type        = number
  default     = 8000
}

variable "target_group_protocol" {
  description = "Protocol to the targets (HTTP)"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/health/"
}

variable "enable_http_redirect" {
  description = "Create HTTP (80) listener that redirects to HTTPS"
  type        = bool
  default     = true
}

variable "idle_timeout_seconds" {
  description = "ALB idle timeout"
  type        = number
  default     = 60
}
