locals {
  domain_name     = "${var.env == "test" ? "dev" : "prod"}.backend.inlocon.de"
  certificate_arn = data.aws_acm_certificate.this.arn
}

data "aws_acm_certificate" "this" {
  domain      = local.domain_name
  statuses    = ["ISSUED"]
  most_recent = true # if several certificates for that domain exist, return the most_recent
}

module "alb" {
  source          = "../../modules/6_alb"
  env             = var.env
  vpc_id          = module.network.vpc_id
  subnet_ids      = module.network.public_subnet_ids
  certificate_arn = local.certificate_arn
  # set this guy to false when certificate has not been validated yet
  enable_http_redirect = true
  # set by default
  # target_groupt_port = 8000
  # target_group_protocol = "HTTP"
  # health_check_path = "/health/"
  # idle_timeout_seconds = 60
}

