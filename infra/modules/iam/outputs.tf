output "role_name_ec2_loader" {
  description = "Name of the role attached to the EC2 loader."
  value       = aws_iam_role.ec2_loader.name
}
