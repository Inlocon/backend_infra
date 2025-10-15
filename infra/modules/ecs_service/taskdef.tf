############################################
# Task Definition
############################################

resource "aws_ecs_task_definition" "this" {
  family                   = var.name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

  execution_role_arn = var.create_execution_role ? aws_iam_role.execution[0].arn : null
  task_role_arn      = var.create_task_role ? aws_iam_role.task[0].arn : null

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
          awslogs-group         = local.log_group_name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = var.container_name
        }
      }
      environment = local.container_env
      secrets     = local.container_secrets
    }
  ])
}

data "aws_region" "current" {}
