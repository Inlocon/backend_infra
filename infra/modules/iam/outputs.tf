output "role_name_ec2_loader" {
  description = "Name of the role attached to the EC2 loader."
  value       = aws_iam_role.ec2_loader.name
}

output "role_name_webservice_execution" {
  value       = aws_iam_role.webservice_execution.name
}

output "role_name_webservice_task" {
  value       = aws_iam_role.webservice_task.name
}
