module "ecr_backend" {
  source = "../../modules/ecr"
  name = "webservice"
  env = var.env
}

# add repo for sync container later