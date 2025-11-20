module "acm_certificate" {
  source = "../../modules/acm_certificate"
  domain_name = "dev.backend.inlocon.de"
}

# add stuff for load balancing here
resource "aws_ssm_parameter" "workflow_test" {
  name  = "/infra/test"
  type  = "String"
  value = "ok"

  overwrite = true
}