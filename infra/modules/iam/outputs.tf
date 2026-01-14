output "ec2_loader_role_arn" { value = aws_iam_role.ec2_loader.arn }
output "ec2_loader_role_name" { value = aws_iam_role.ec2_loader.name }

output "webservice_execution_role_arn" { value = aws_iam_role.webservice_execution.arn }
output "webservice_execution_role_name" { value = aws_iam_role.webservice_execution.name }

output "webservice_task_role_arn" { value = aws_iam_role.webservice_task.arn }
output "webservice_task_role_name" { value = aws_iam_role.webservice_task.name }


