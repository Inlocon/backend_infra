locals {
  domain_name = "${var.env == "test" ? "dev" : "prod"}.backend.inlocon.de"
}

resource "aws_acm_certificate" "this" {
  domain_name               = local.domain_name
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

module "alb" {
  source = "../../modules/alb"
  env = var.env
  vpc_id = module.network.vpc_id
  subnet_ids = module.network.public_subnet_ids
  certificate_arn = aws_acm_certificate.this.arn
  # set this guy to false when certificate has not been validated yet
  enable_http_redirect = true
  # set by default
  # target_groupt_port = 8000
  # target_group_protocol = "HTTP"
  # health_check_path = "/health/"
  # idle_timeout_seconds = 60
}

