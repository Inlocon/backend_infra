resource "aws_security_group" "tasks" {
  name        = "${var.env}-${var.name}-tasks"
  description = "SG for ECS tasks"
  vpc_id      = var.vpc_id
  tags = var.tags
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.env}-${var.name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

  # from iam.tf
  execution_role_arn = aws_iam_role.execution.arn
  task_role_arn      = aws_iam_role.task.arn

  container_definitions = jsonencode([
    {
      name        = var.container_name
      image       = var.container_image
      essential   = true

      portMappings = [{
        containerPort = var.container_port
        protocol      = "tcp"
      }]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = var.container_name
        }
      }

      environmentFiles = [{
          type  = "s3"
          value = "arn:aws:s3:::${var.env_s3_bucket_name}/${var.env_s3_bucket_key}" }]
    }
  ])

  # does not change much, but doesn't hurt either
  tags = var.tags
}

data "aws_region" "current" {}
