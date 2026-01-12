variable "env" {
  description = "test/prod"
  type        = string
  default     = "test"
}

##################
# EC2 loader role
##################

variable "secret_name_db_credentials" {
  description = "Name of the secret from secretmanager for db credentials"
  type        = string
}

variable "bucket_name" {
  description = "Bucket for database dumps and config files."
  type        = string
}