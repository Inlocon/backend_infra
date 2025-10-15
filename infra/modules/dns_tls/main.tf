# Request certificate in the same region as the ALB
resource "aws_acm_certificate" "this" {
  domain_name       = var.certificate_domain
  validation_method = "DNS"
  subject_alternative_names = var.san_names
  tags = merge({ Name = "${var.name}-cert" }, var.tags)
}

# Create DNS validation records in Route53 for each required validation option
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = var.hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# Validate the certificate
resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}

# Create an ALIAS A-record pointing the hostname to the ALB
resource "aws_route53_record" "app_alias" {
  zone_id = var.hosted_zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }

  depends_on = [aws_acm_certificate_validation.this]
}
