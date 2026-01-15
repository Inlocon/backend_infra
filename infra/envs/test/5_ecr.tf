module "webservice_ecr_repo" {
  source = "../../modules/ecr"
  name   = "webservice"
  env    = var.env
}

module "dbsync_ecr_repo" {
  source = "../../modules/ecr"
  name   = "dbsync"
  env    = var.env
}
