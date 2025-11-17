variable "env" {
  type    = string
  default = "test"
}

variable "default_tags" {
  type = map(string)
  default = {
    env = "test"
    managedBy = "terraform"
  }
}
