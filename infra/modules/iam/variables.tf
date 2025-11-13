variable "env" {
  description = "Should be 'test' or 'prod'."
  type        = string
  default     = "test"
}

##################
# EC2 loader role
##################

variable "secret_name_db_credentials" {
  description = "Name of the secret from secretmanager for db credentials"
  type        = string
  default     = "test_db_credentials"
}

variable "ec2_loader_s3_bucket_name" {
  description = "Name of the bucket from which the ec2 loader instance fetches the dump."
  type        = string
  default     = "backend-inlocon"
}