# ################################
# # Postgres, single-AZ, private
# ################################

module "rds" {
  source = "../../modules/2_rds"
  env        = var.env

  # networking/ access
  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids
  secret_name_db_credentials = local.secret_name_db_credentials

  engine                = "postgres"
  engine_version        = null # aws picks default, currently 17
  instance_class        = "db.t4g.medium"
  allocated_storage     = 70 # GB
  backup_retention_days = 7 # days

  publicly_accessible = false
  deletion_protection = false
  apply_immediately   = true

}

resource "aws_security_group_rule" "db_from_ec2" {
  type                     = "ingress"
  security_group_id        = module.rds.db_sg_id
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = module.ec2_loader.security_group_id
}

resource "aws_security_group_rule" "db_from_webservice" {
  type                     = "ingress"
  security_group_id        = module.rds.db_sg_id
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = module.webservice.task_sg_id
}

resource "aws_security_group_rule" "db_from_dbsync" {
  type                     = "ingress"
  security_group_id        = module.rds.db_sg_id
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = module.dbsync.task_sg_id
}