# ################################
# # Postgres, single-AZ, private
# ################################
#
# locals {
#   rds_instance_class    = "db.t4g.small" # maybe .small might be enough for testing
#   rds_allocated_storage = 60             # GB; should be higher for production
#   rds_backup_retention  = 7              # days (test)
# }
#
# module "rds" {
#   source = "../../modules/2_rds"
#
#   env        = var.env
#   vpc_id     = module.network.vpc_id
#   subnet_ids = module.network.private_subnet_ids
#   secret_name_db_credentials = local.secret_name_db_credentials
#
#   # Engine/version (module defaults to postgres 17; leave null to let AWS pick a minor)
#   engine_version        = null
#   instance_class        = local.rds_instance_class
#   allocated_storage     = local.rds_allocated_storage
#   backup_retention_days = local.rds_backup_retention
#
#   # Private, single-AZ, sane defaults for test
#   publicly_accessible = false
#   deletion_protection = false
#   apply_immediately   = true
#
# }
#
# resource "aws_security_group_rule" "db_from_ec2" {
#   type                     = "ingress"
#   security_group_id        = module.rds.db_sg_id
#   protocol                 = "tcp"
#   from_port                = 5432
#   to_port                  = 5432
#   source_security_group_id = module.ec2_loader.security_group_id
# }
#
# resource "aws_security_group_rule" "db_from_webservice" {
#   type                     = "ingress"
#   security_group_id        = module.rds.db_sg_id
#   protocol                 = "tcp"
#   from_port                = 5432
#   to_port                  = 5432
#   source_security_group_id = module.webservice.task_sg_id
# }