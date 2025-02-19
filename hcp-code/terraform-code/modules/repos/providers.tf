terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.5.0"
    }
  }
}

provider "github" {
  owner = "<YOUR_GITHUB_ACCOUNT>" # GitHub organization or user name
}