#####################
# descriptive labels
#####################
variable "name" {
  description = "Service name/prefix (e.g. webservice)"
  type        = string
  default = "webservice"
}

variable "env" {
  description = "Environment name (test/prod)."
  type        = string
}

variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {resourceGroup = "webservice"}
}

######
# IAM
######

variable "webservice_execution_role_arn" {
  type        = string
}

variable "webservice_task_role_arn" {
  type        = string
}


##########################################
# networking (public tasks, single-AZ OK)
##########################################
variable "vpc_id" {
  description = "VPC where tasks run"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets where tasks run"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign public IP to tasks (true for no-NAT egress)"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of the cluster where service should run."
  type        = string
}

############
# Container
############
variable "container_image" {
  description = "Image URI (e.g., ECR repo:tag)"
  type        = string
}

variable "container_name" {
  description = "Container name for task definition"
  type        = string
  default     = "webservice"
}

variable "container_port" {
  description = "App port exposed by the container"
  type        = number
  default     = 8000
}

variable "cpu" {
  description = "Task CPU units (e.g., 256, 512, 1024; 1 vCPU = 1024)"
  type        = number
  default     = 512
}

variable "memory" {
  description = "Task memory in MiB (e.g., 1024, 2048)"
  type        = number
  default     = 1024
}

variable "env_s3_bucket_name" {
  description = "S3 bucket name to pull env file from"
  type        = string
}

variable "env_s3_bucket_key" {
  description = "S3 bucket key to pull env file from"
  type        = string
}

################
# Load balancer
################
variable "target_group_arn" {
  description = "Service registers this container/port with the ALB target group"
  type        = string
  default     = null
}

############################################
# Scaling
############################################
variable "desired_count" {
  description = "Number of tasks to run"
  type        = number
  default     = 1
}

variable "autoscaling_min" {
  description = "Minimum tasks when autoscaling is enabled"
  type        = number
  default     = 1
}

variable "autoscaling_max" {
  description = "Maximum tasks when autoscaling is enabled"
  type        = number
  default     = 1
}

variable "cpu_target_percent" {
  description = "Target CPU utilization for autoscaling (if enabled)"
  type        = number
  default     = 60
}

#######
# logs
#######

variable "log_group_name" {
  description = "Use a specific log group name"
  type        = string
  default     = null
}