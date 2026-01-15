###############################################################
# minimal, as these values are hardly ever used/seen by anyone
###############################################################

###############
# 1_NETWORKING
###############

output "vpc_id" { value = module.network.vpc_id }
output "public_subnet_ids" { value = module.network.public_subnet_ids }
output "private_subnet_ids" { value = module.network.private_subnet_ids }

########
# 2_RDS
########
output "db_endpoint" { value = module.rds.db_endpoint }
output "db_port" { value = module.rds.db_port }
