variable "env" {
  description = "test/prod"
  type = string
  default = "test"
}

variable "vpc_config" {
  description = "VPC settings"
  type = object({
    cidr_block = string
    name       = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "vpc_config.cidr_block must be a valid CIDR (e.g., 10.10.0.0/16)."
  }
}

variable "subnet_config" {
  description = <<EOT
Map of subnet configs keyed by a friendly name.
Example:
{
  public-a  = { cidr_block = "10.10.0.0/24", public = true,  az = "eu-central-1a" }
  private-a = { cidr_block = "10.10.1.0/24", public = false, az = "eu-central-1a" }
}
EOT
  type = map(object({
    cidr_block = string
    public     = optional(bool, false)
    az         = string
  }))

  validation {
    condition     = alltrue([for c in values(var.subnet_config) : can(cidrnetmask(c.cidr_block))])
    error_message = "Every subnet_config.cidr_block must be a valid CIDR."
  }
}

