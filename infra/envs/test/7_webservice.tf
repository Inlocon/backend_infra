module "ecs_cluster" {
  source = "../../modules/ecs_cluster"
  env = var.env
}
