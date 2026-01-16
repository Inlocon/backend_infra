################
# Data & locals
################

locals {
  family        = "postgres${var.engine_major}"
  secret_name   = coalesce(var.secret_name, "${var.env}_db_credentials")
  username_safe = var.username
  tags = {resourceGroup = "${var.env}_db"}
}

############################################
# Networking bits for RDS
############################################

# allow-list of subnets where aws may place the instance
resource "aws_db_subnet_group" "this" {
  name       = "${var.env}_db_subnet_grp"
  subnet_ids = var.subnet_ids
  tags = local.tags
}

# sg attached to the db
resource "aws_security_group" "db" {
  name        = "${var.env}_db_sg"
  description = "DB SG (${var.env})"
  vpc_id      = var.vpc_id
  tags = local.tags
}

# sg attached to the db
resource "aws_security_group" "db_" {
  name        = "${var.env}-db-sg"
  description = "DB SG (${var.env})"
  vpc_id      = var.vpc_id
  tags = local.tags
}


############################################
# Parameter group (minimal sane defaults)
############################################

resource "aws_db_parameter_group" "this" {
  name        = "parameter-group-${var.env}-db"
  family      = local.family
  description = "Param group for ${var.env}-db"

  parameter {
    name  = "log_min_duration_statement"
    value = "3000"
  }

  parameter {
    name  = "idle_in_transaction_session_timeout"
    value = "60000"
  }

  tags = local.tags
}

########################################################
# Secrets: generate password + store in Secrets Manager
########################################################

resource "random_password" "db" {
  length = 32
}

resource "aws_secretsmanager_secret" "db" {
  description = "Zugangsdaten für ${var.env}-Datenbank."
  name = local.secret_name
  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "creds" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username = local.username_safe
    password = random_password.db.result
  })
}

############################################
# The DB instance (single-AZ, private)
############################################

resource "aws_db_instance" "this" {
  identifier              = "${var.env}-db"
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.db.id, aws_security_group.db_.id]
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  storage_encrypted       = true

  db_name                 = "${var.env}_db"
  username                = local.username_safe
  password                = random_password.db.result
  port                    = var.port

  publicly_accessible     = var.publicly_accessible
  multi_az                = false
  deletion_protection     = var.deletion_protection
  backup_retention_period = var.backup_retention_days
  apply_immediately       = var.apply_immediately

  parameter_group_name    = aws_db_parameter_group.this.name
  skip_final_snapshot     = true

  tags = local.tags
}

# Second secret version: add connection details after instance exists
resource "aws_secretsmanager_secret_version" "connection" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    engine   = var.engine
    host     = aws_db_instance.this.address
    port     = var.port
    dbname   = "${var.env}_db"
    username = local.username_safe
    password = random_password.db.result
  })
  depends_on = [aws_db_instance.this]
}
