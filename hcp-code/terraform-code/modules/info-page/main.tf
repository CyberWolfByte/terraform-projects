data "terraform_remote_state" "repos" {
  backend = "remote"

  config = {
    organization = "CWB-TF-2025" # Replace with your Terraform Cloud organization name
    workspaces = {
      name = "cwb-repos"
    }
  }
}

locals {
  repos = {
    for k, v in data.terraform_remote_state.repos.outputs.clone_urls["prod"].clone-urls :
    k => {
      http-clone-url = v.http-clone-url
      pages-url      = lookup(v, "pages-url", "no page")
    }
  }
}

resource "github_repository" "info_repo" {
  name        = "tf_info_page"
  description = "Repository Information for TF"
  # Make all repositories public, removing GitHub free account limitations for GitHub Pages
  visibility = "public"
  auto_init  = true
  pages {
    source {
      branch = "main"
      path   = "/"
    }
  }
  provisioner "local-exec" {
    command = var.run_provisioner ? "gh repo view ${self.name} --web" : "echo 'Skip repo view'"
  }
}

data "github_user" "current" {
  username = ""
}

resource "time_static" "fecha" {
}

resource "github_repository_file" "index" {
  repository          = github_repository.info_repo.name
  branch              = "main"
  file                = "index.md"
  overwrite_on_create = true
  content = templatefile("${path.module}/templates/index.tftpl", {
    avatar = data.github_user.current.avatar_url,
    name   = data.github_user.current.name,
    date   = time_static.fecha.year
    repos  = local.repos
  })
}