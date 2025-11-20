module "acm_certificate" {
  source = "../../modules/acm_certificate"
  domain_name = "dev.backend.inlocon.de"
}

# add stuff for load balancing here