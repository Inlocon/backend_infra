variable "name" {
  description = "Base name of the ECR repository (without env prefix, if you use one)."
  type        = string
}

variable "env" {
  description = "Environment name (test/prod)."
  type        = string
}

variable "image_tag_mutability" {
  description = "Whether image tags are mutable or immutable."
  type        = string
  default     = "MUTABLE" # or "IMMUTABLE"
}

variable "scan_on_push" {
  description = "Enable image scanning on push (useful for detecting security vulnerabilities)."
  type        = bool
  default     = false
}
