variable "env" {
  type = string
  default = "test"
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "route_table_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}


