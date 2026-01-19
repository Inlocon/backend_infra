resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = var.cluster_arn
  launch_type     = "FARGATE"
  platform_version = "LATEST"
  desired_count = 1


  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.task.id]
    assign_public_ip = var.assign_public_ip
  }

  task_definition = aws_ecs_task_definition.this.arn

  enable_execute_command = true
  tags = var.tags
}