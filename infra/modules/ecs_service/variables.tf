############################################
# Identity & basics
############################################
variable "name" {
  description = "Service name/prefix (e.g., test-app, prod-app)"
  type        = string
}

variable "cluster_name" {
  description = "ECS cluster name (module may create or you pass an existing one later)"
  type        = string
  default     = null
}

############################################
# Networking (public tasks, single-AZ OK)
############################################
variable "subnet_ids" {
  description = "Subnets where tasks run (public for public IP tasks)"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups attached to the tasks"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign public IP to tasks (true for no-NAT egress)"
  type        = bool
  default     = true
}

############################################
# Container image & runtime
############################################
variable "container_image" {
  description = "Image URI (e.g., ECR repo:tag)"
  type        = string
}

variable "container_name" {
  description = "Container name for task definition"
  type        = string
  default     = "inlocon_backend"
}

variable "container_port" {
  description = "App port exposed by the container"
  type        = number
  default     = 8000
}

variable "cpu" {
  description = "Task CPU units (e.g., 256, 512, 1024)"
  type        = number
  default     = 512
}

variable "memory" {
  description = "Task memory in MiB (e.g., 1024, 2048)"
  type        = number
  default     = 1024
}

############################################
# Env & secrets (Django config)
############################################
variable "env" {
  description = "Plain environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = <<EOT
Map of container env var name -> valueFrom ARN (Secrets Manager or SSM Parameter).
Example:
  {
    DB_SECRET_JSON = "arn:aws:secretsmanager:...:secret:prod/db-abc",
    DJANGO_SECRET  = "arn:aws:ssm:eu-central-1:123456789012:parameter/app/prod/secret_key"
  }
EOT
  type    = map(string)
  default = {}
}

############################################
# Load balancer integration (optional)
############################################
variable "target_group_arn" {
  description = "If set, service registers this container/port with the ALB target group"
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

variable "autoscaling_enabled" {
  description = "Enable target-tracking autoscaling"
  type        = bool
  default     = false
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

############################################
# IAM & logs
############################################
variable "create_execution_role" {
  description = "Create an execution role (pull image, send logs) if true"
  type        = bool
  default     = true
}

variable "execution_role_name" {
  description = "Optional custom name for execution role (if created)"
  type        = string
  default     = null
}

variable "create_task_role" {
  description = "Create a task role (app permissions) if true"
  type        = bool
  default     = true
}

variable "task_role_name" {
  description = "Optional custom name for task role (if created)"
  type        = string
  default     = null
}

variable "task_role_policy_arns" {
  description = "Optional extra policy ARNs to attach to the task role (e.g., read S3 config)"
  type        = list(string)
  default     = []
}

variable "create_log_group" {
  description = "Create a dedicated CloudWatch Logs group"
  type        = bool
  default     = true
}

variable "log_group_name" {
  description = "Use a specific log group name (if not created, it's expected to exist)"
  type        = string
  default     = null
}

variable "log_retention_days" {
  description = "Retention in days for the log group (if created)"
  type        = number
  default     = 14
}
