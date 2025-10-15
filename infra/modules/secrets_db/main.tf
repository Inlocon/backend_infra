locals {
  final_password = coalesce(var.password, random_password.this[0].result)
  base_payload = {
    engine   = var.engine
    host     = var.host
    port     = var.port
    dbname   = var.dbname
    username = var.username
    password = local.final_password
  }
  merged_payload = merge(local.base_payload, var.extra_payload)
}

resource "random_password" "this" {
  count              = var.password == null ? 1 : 0
  length             = 32
  special            = true
  override_special = "!#%^*-_=+"
}

resource "aws_secretsmanager_secret" "this" {
  name       = var.name
  kms_key_id = var.kms_key_id
  tags       = merge({ Name = var.name }, var.tags)
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(local.merged_payload)
}
