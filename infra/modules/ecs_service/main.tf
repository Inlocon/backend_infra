############################################
# Locals & helpers
############################################

locals {
  # Cluster name: use provided or the one we create
  cluster_name = coalesce(var.cluster_name, try(aws_ecs_cluster.this[0].name, null))

  # Log group name: provided or default
  log_group_name = coalesce(var.log_group_name, "/ecs/${var.name}")

  # Container env/secrets shaped for task definition
  container_env = [
    for k, v in var.env : { name = k, value = v }
  ]

  container_secrets = [
    for k, v in var.secrets : { name = k, valueFrom = v }
  ]
}

############################################
# ECS Cluster (optional)
############################################

resource "aws_ecs_cluster" "this" {
  count = var.cluster_name == null ? 1 : 0
  name  = var.name
}

############################################
# CloudWatch Logs (optional)
############################################

resource "aws_cloudwatch_log_group" "this" {
  count             = var.create_log_group ? 1 : 0
  name              = local.log_group_name
  retention_in_days = var.log_retention_days
}




