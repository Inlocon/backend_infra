variable "env" {
  type    = string
  default = "common"
}

variable "default_tags" {
  type = map(string)
  default = {
    env = "common"
    managedBy = "terraform"
  }
}
