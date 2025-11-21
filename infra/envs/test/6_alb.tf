module "acm_certificate" {
  source = "../../modules/acm_certificate"
  domain_name = "dev.backend.inlocon.de"
}

module "alb" {
  source = "../../modules/alb"
  env = var.env
  vpc_id = module.network.vpc_id
  subnet_ids = module.network.public_subnet_ids
  certificate_arn = module.acm_certificate.arn
  # set by default
  # target_groupt_port = 8000
  # target_group_protocol = "HTTP"
  # health_check_path = "/health/"
  # enable_http_redirect = true
  # idle_timeout_seconds = 60
}

