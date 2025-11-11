################################
# Postgres, single-AZ, private
################################

locals {
  rds_instance_class      = "db.t4g.small" # maybe .small might be enough for testing
  rds_allocated_storage   = 60              # GB
  rds_backup_retention    = 3               # days (test)
}

module "rds" {
  source = "../../modules/rds"

  name        = "test"
  vpc_id      = module.network.vpc_id
  subnet_ids  = module.network.private_subnet_ids  # private subnets from network module

  # Engine/version (module defaults to postgres 17; leave null to let AWS pick a minor)
  engine_version        = null
  instance_class        = local.rds_instance_class
  allocated_storage     = local.rds_allocated_storage
  backup_retention_days = local.rds_backup_retention

  # Private, single-AZ, sane defaults for test
  publicly_accessible = false
  deletion_protection = false
  apply_immediately   = true

}

# allow connection to test_db from an EC2 instance -> create later, when
# ec2_loader module is integrated
resource "aws_security_group_rule" "test_db_access_from_ec2" {
  type                     = "ingress"
  security_group_id        = module.rds.db_sg_id
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = "sg-0a971c59890a989c0"
}