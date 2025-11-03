variable "name" {
  description = "Short name/prefix for tags and resource names (e.g., test, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID (for the DB security group)"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for the DB subnet group (1–2, single AZ is fine)"
  type        = list(string)
}

variable "engine" {
  description = "RDS engine"
  type        = string
  default     = "postgres"
}

variable "engine_major" {
  description = "Engine major version for parameter group family (e.g., 17). Leave default unless you need older."
  type        = number
  default     = 17
}

variable "engine_version" {
  description = "Exact engine version (optional). If null, AWS picks a current default."
  type        = string
  default     = null
}

variable "instance_class" {
  description = "DB instance class (e.g., db.t4g.small). Set per-environment."
  type        = string
}

variable "allocated_storage" {
  description = "Storage size in GB (GP3 recommended). Set per-environment."
  type        = number
}

variable "storage_type" {
  description = "Storage type"
  type        = string
  default     = "gp3"
}

variable "username" {
  description = "Master username"
  type        = string
  default     = "postgres"
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

variable "publicly_accessible" {
  description = "Should the DB be publicly accessible? (No for private)"
  type        = bool
  default     = false
}

variable "port" {
  description = "DB port"
  type        = number
  default     = 5432
}

variable "apply_immediately" {
  description = "Apply changes immediately (true) vs during maintenance window"
  type        = bool
  default     = true
}

variable "create_random_password" {
  description = "If true, generate a random password and store in Secrets Manager"
  type        = bool
  default     = true
}

variable "secret_name" {
  description = "Optional Secrets Manager name (if null, module will choose a sensible default)"
  type        = string
  default     = null
}
