# terraform {
#   cloud {

#     organization = "CWB-TF-2025"

#     workspaces {
#       name = "ecs"
#     }
#   }
# }

terraform {
  backend "s3" {
    bucket       = "cwb-app-state-21725"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

