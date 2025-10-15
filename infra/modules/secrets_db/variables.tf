variable "name" {
  description = "Secret name (e.g., test/db)"
  type        = string
}

variable "engine" {
  description = "DB engine label stored in the secret (e.g., postgres)"
  type        = string
  default     = "postgres"
}

variable "host" {
  description = "DB host DNS name"
  type        = string
}

variable "port" {
  description = "DB port"
  type        = number
  default     = 5432
}

variable "dbname" {
  description = "Database name"
  type        = string
  default     = "appdb"
}

variable "username" {
  description = "DB username"
  type        = string
  default     = "app"
}

variable "password" {
  description = "DB password (if null, a random one will be generated)"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "Optional KMS key ID/ARN for the secret (else AWS-managed key)"
  type        = string
  default     = null
}

variable "extra_payload" {
  description = "Optional extra JSON fields to merge into the secret"
  type        = map(any)
  default     = {}
}

variable "tags" {
  description = "Optional tags"
  type        = map(string)
  default     = {}
}
