variable "env" {
  description = "test/prod"
  type        = string
}

variable "bucket_name" {
  type        = string
}

variable "force_destroy" {
  description = "Delete all objects on destroy (automatically)."
  type        = bool
  default     = true
}

variable "deny_insecure_transport" {
  description = "Deny non-TLS (http) access."
  type        = bool
  default     = true
}
