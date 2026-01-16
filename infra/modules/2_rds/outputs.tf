output "db_endpoint" {
  description = "DNS address of the DB instance"
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "Port the DB listens on"
  value       = aws_db_instance.this.port
}

output "db_sg_old_id" {
  description = "Security Group ID attached to the DB"
  value       = aws_security_group.db.id
}

output "db_sg_id" {
  description = "Security Group ID attached to the DB"
  value       = aws_security_group.db_.id
}


output "secret_arn" {
  description = "Secrets Manager secret ARN holding DB credentials/connection"
  value       = aws_secretsmanager_secret.db.arn
}
