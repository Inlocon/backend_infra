output "certificate_arn" {
  description = "Validated ACM certificate ARN"
  value       = aws_acm_certificate.this.arn
}

output "record_fqdn" {
  description = "Created Route53 record FQDN"
  value       = aws_route53_record.app_alias.fqdn
}
