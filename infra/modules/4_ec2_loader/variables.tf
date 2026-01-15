variable "env" {
  description = "test/prod"
  type        = string
  default     = "test"
}

variable "ami_id" {
  description = "AMI to launch."
  type        = string
}

variable "iam_role_name" {
  description = "Existing IAM role name to wrap in an instance profile."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "name" {
  description = "Name of the created EC2 instance"
  type        = string
  default     = "ec2-db-connector"
}

variable "subnet_id" {
  description = "Subnet where the instance will live."
  type        = string
}

variable "volume_size_gb" {
  description = "Root volume size in GB."
  type        = number
  default     = 20
}
