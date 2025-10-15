############################################
# IAM Roles (Execution & Task)
############################################

data "aws_iam_policy" "ecs_execution_managed" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "execution" {
  count = var.create_execution_role ? 1 : 0
  name  = coalesce(var.execution_role_name, "${var.name}-exec")
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "execution_attach" {
  count      = var.create_execution_role ? 1 : 0
  role       = aws_iam_role.execution[0].name
  policy_arn = data.aws_iam_policy.ecs_execution_managed.arn
}

resource "aws_iam_role" "task" {
  count = var.create_task_role ? 1 : 0
  name  = coalesce(var.task_role_name, "${var.name}-task")
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "task_extra" {
  count      = var.create_task_role ? length(var.task_role_policy_arns) : 0
  role       = aws_iam_role.task[0].name
  policy_arn = var.task_role_policy_arns[count.index]
}