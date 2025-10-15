output "bucket_name" {
  description = "Name of the config bucket"
  value       = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "ARN of the config bucket"
  value       = aws_s3_bucket.this.arn
}

output "read_prefix" {
  description = "Configured prefix for config files"
  value       = var.read_prefix
}

output "object_arn_prefix" {
  description = "ARN prefix for objects under the read_prefix"
  value       = "${aws_s3_bucket.this.arn}/${var.read_prefix}"
}

output "execution_role_read_policy_json" {
  description = "Inline policy JSON granting read-only access to the prefix (attach to ECS execution role)"
  value       = data.aws_iam_policy_document.read_prefix.json
}
