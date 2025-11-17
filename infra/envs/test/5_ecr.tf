module "ecr_backend" {
  source = "../../modules/ecr"
  name = "backend"
  env = var.env
}

# add repo for sync container later