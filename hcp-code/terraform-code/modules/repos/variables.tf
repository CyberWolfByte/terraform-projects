variable "deploy_key" {
  type    = bool
  default = false
}

variable "environments" {
  type    = set(string)
  default = ["dev", "prod"]
}