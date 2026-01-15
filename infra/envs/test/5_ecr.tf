module "webservice_ecr_repo" {
  source = "../../modules/ecr"
  name   = "webservice"
  env    = var.env
}

# add repo for sync container later