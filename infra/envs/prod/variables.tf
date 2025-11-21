variable "env" {
  type    = string
  default = "common"
}

variable "default_tags" {
  type = map(string)
  default = {
    env = "test"
    managedBy = "terraform"
  }
}
