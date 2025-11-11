module "vpc_endpoints" {
  source            = "../../modules/vpc_endpoints"
  env = "test"
  vpc_id = module.network.vpc_id
  vpc_cidr_block = module.network.vpc_cidr_block
  route_table_ids = [module.network.private_route_table_id, module.network.public_route_table_id]
  private_subnet_ids = module.network.private_subnet_ids
}
