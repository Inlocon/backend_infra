variable "name" {
  description = "Logical name/prefix for tags"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID (e.g., for backend.mycompany.de)"
  type        = string
}

variable "record_name" {
  description = "Record name to create, e.g., terratest.backend.mycompany.de"
  type        = string
}

variable "alb_dns_name" {
  description = "ALB DNS name to target with an alias (e.g., from alb module output)"
  type        = string
}

variable "alb_zone_id" {
  description = "ALB hosted zone ID (from aws_lb.this.zone_id)"
  type        = string
}

variable "certificate_domain" {
  description = "Domain for ACM certificate (usually same as record_name)"
  type        = string
}

variable "san_names" {
  description = "Optional Subject Alternative Names for the certificate"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Optional tags"
  type        = map(string)
  default     = {}
}
