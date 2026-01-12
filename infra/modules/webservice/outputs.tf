output "service_name" {
  description = "Name of the ECS service."
  value       = aws_ecs_service.this.name
}

output "task_definition_arn" {
  description = "ARN of the ECS task definition."
  value       = aws_ecs_task_definition.this.arn
}

output "task_sg_id" {
  description = "Security group ID attached to ECS tasks."
  value       = aws_security_group.tasks.id
}

output "task_role_arn" {
  description = "ARN of the ECS task role (with S3 .env access)."
  value       = aws_iam_role.task.arn
}

output "execution_role_arn" {
  description = "ARN of the ECS execution role (for ECR/logs/exec)."
  value       = aws_iam_role.execution.arn
}
