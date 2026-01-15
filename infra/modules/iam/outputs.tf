output "ec2_loader_role_arn" { value = aws_iam_role.ec2_loader.arn }
output "ec2_loader_role_name" { value = aws_iam_role.ec2_loader.name }

output "webservice_execution_role_arn" { value = aws_iam_role.webservice_execution.arn }
output "webservice_execution_role_name" { value = aws_iam_role.webservice_execution.name }

output "webservice_task_role_arn" { value = aws_iam_role.webservice_task.arn }
output "webservice_task_role_name" { value = aws_iam_role.webservice_task.name }

output "dbsync_execution_role_arn" { value = aws_iam_role.dbsync_execution.arn }
output "dbsync_execution_role_name" { value = aws_iam_role.dbsync_execution.name }

output "dbsync_task_role_arn" { value = aws_iam_role.dbsync_task.arn }
output "dbsync_task_role_name" { value = aws_iam_role.dbsync_task.name }

