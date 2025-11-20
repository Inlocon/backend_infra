output "arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.this.arn
}

output "domain_name" {
  description = "Primary domain name for this certificate"
  value       = aws_acm_certificate.this.domain_name
}

output "domain_validation_options" {
  description = "DNS records that must be created at the DNS provider for validation"
  value       = aws_acm_certificate.this.domain_validation_options
}
