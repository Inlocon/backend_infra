############################################
# Data & locals
############################################

locals {
  family        = "postgres${var.engine_major}"                # e.g., postgres16
  secret_name   = coalesce(var.secret_name, "${var.name}_db")  # e.g., test/db
  username_safe = var.username
}

############################################
# Networking bits for RDS
############################################

# Subnet group (use your private subnet IDs; single-AZ is fine with 1 subnet)
resource "aws_db_subnet_group" "this" {
  name       = "${var.name}_db_subnet_grp"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "${var.name}_db_subnet_grp"
  }
}

# Security group: no ingress yet; we'll wire ECS -> DB later from env layer
resource "aws_security_group" "db" {
  name        = "${var.name}_db_sg"
  description = "DB SG (${var.name})"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name}_db_sg" }
}

############################################
# Parameter group (minimal sane defaults)
############################################

resource "aws_db_parameter_group" "this" {
  name        = "${var.name}_pg"
  family      = local.family
  description = "Param group for ${var.name}"

  # Minimal, safe tweaks (PostgreSQL)
  parameter {
    name  = "log_min_duration_statement"
    value = "1000"  # 1s slow query threshold
  }

  parameter {
    name  = "idle_in_transaction_session_timeout"
    value = "60000" # 60s
  }

  tags = { Name = "${var.name}_pg" }
}

############################################
# Secrets: generate password + store in Secrets Manager
############################################

resource "random_password" "db" {
  length           = 32
  override_characters = "!@#%^*-_=+"
  special          = true
}

resource "aws_secretsmanager_secret" "db" {
  name = local.secret_name
  tags = { Name = "${var.name}_db_secret" }
}

# First version: username/password only (available before instance exists)
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
  identifier              = "${var.name}_db"
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.db.id]
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  storage_encrypted       = true

  name                    = var.db_name
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

  tags = { Name = "${var.name}_db" }
}

# Second secret version: add connection details after instance exists
resource "aws_secretsmanager_secret_version" "connection" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    engine   = var.engine
    host     = aws_db_instance.this.address
    port     = var.port
    dbname   = var.db_name
    username = local.username_safe
    password = random_password.db.result
  })
  depends_on = [aws_db_instance.this]
}
