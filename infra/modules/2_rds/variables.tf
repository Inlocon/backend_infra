variable "allocated_storage" {
  description = "Storage size in GB (GP3 recommended). Set per-environment."
  type        = number
}

variable "apply_immediately" {
  description = "Apply changes immediately (true) vs during maintenance window"
  type        = bool
  default     = true
}

variable "backup_retention_days" {
  description = "Automated backup retention (days). Set per-environment."
  type        = number
}

variable "deletion_protection" {
  description = "Protect DB from deletion"
  type        = bool
  default     = false
}

variable "env" {
  description = "test/prod"
  type        = string
}

variable "enabled_cloudwatch_logs_exports" {
  type    = list(string)
  default = []
}

variable "engine" {
  description = "RDS engine"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Exact engine version (optional, e.g.: 15.4). If null, AWS picks a current default."
  type        = string
  default     = null
}

variable "instance_class" {
  description = "DB instance class (e.g., db.t4g.small). Set per-environment."
  type        = string
}

variable "port" {
  description = "DB port"
  type        = number
  default     = 5432
}

variable "publicly_accessible" {
  description = "Should the DB be publicly accessible? (No for private)"
  type        = bool
  default     = false
}

variable "secret_name_db_credentials" {
  description = "Secrets Manager name"
  type        = string
  default     = null
}

variable "snapshot_identifier" {
  description = "Necessary, if db should be created from snaphot"
  type        = string
  default     = null
}

variable "storage_type" {
  description = "Storage type"
  type        = string
  default     = "gp3"
}

variable "subnet_ids" {
  description = "Private subnet IDs for the DB subnet group (1–2, single AZ is fine)"
  type        = list(string)
}

variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {resourceGroup = "rds"}
}

variable "username" {
  description = "Master username"
  type        = string
  default     = "postgres"
}

variable "vpc_id" {
  description = "VPC ID (for the DB security group)"
  type        = string
}
