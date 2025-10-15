############################################
# ECS Service
############################################

resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = local.cluster_name
  launch_type     = "FARGATE"
  platform_version = "LATEST"
  desired_count   = var.desired_count

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_group_ids
    assign_public_ip = var.assign_public_ip
  }

  task_definition = aws_ecs_task_definition.this.arn

  # Optional ALB target group registration
  dynamic "load_balancer" {
    for_each = var.target_group_arn == null ? [] : [var.target_group_arn]
    content {
      target_group_arn = load_balancer.value
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  lifecycle {
    ignore_changes = [desired_count] # helpful when autoscaling manages count
  }

  depends_on = [
    aws_ecs_task_definition.this,
    aws_iam_role_policy_attachment.execution_attach,
  ]
}