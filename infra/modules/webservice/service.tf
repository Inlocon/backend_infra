resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = var.cluster_name
  launch_type     = "FARGATE"
  platform_version = "LATEST"
  desired_count   = var.desired_count

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.tasks.id]
    assign_public_ip = var.assign_public_ip
  }

  task_definition = aws_ecs_task_definition.this.arn

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count] # helpful when autoscaling manages count
  }

  # enabling shell into running container
  enable_execute_command = true
  tags = var.tags
}