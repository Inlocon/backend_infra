###############
# 1_NETWORKING
###############

output "vpc_id" { value = module.network.vpc_id }
output "public_subnet_ids" { value = module.network.public_subnet_ids }
output "private_subnet_ids" { value = module.network.private_subnet_ids }

########
# 2_RDS
########
# output "db_endpoint"  { value = module.rds.db_endpoint }
# output "db_port"      { value = module.rds.db_port }
# output "db_secret_arn"{ value = module.rds.secret_arn }
# output "db_sg_id"     { value = module.rds.db_sg_id }
