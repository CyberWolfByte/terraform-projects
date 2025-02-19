locals {
  repos = {
    infra = {
      lang     = "Terraform",
      filename = "main.tf"
      pages    = false
    },
    backend = {
      lang     = "Python",
      filename = "main.py"
      pages    = false
    },
    frontend = {
      lang     = "Javascript",
      filename = "main.js"
      pages    = true
    }
  }
}