resource "github_repository" "tf_repo" {
  for_each    = var.repos
  name        = "tf-${each.key}-${var.env}"
  description = "${each.value.lang} code for Terraform POC"
  # visibility  = var.env == "dev" ? "private" : "public"

  # Make all repositories public, removing GitHub free account limitations for GitHub Pages 
  visibility = "public"
  auto_init  = true
  dynamic "pages" {
    for_each = each.value.pages ? [1] : []
    content {
      source {
        branch = "main"
        path   = "/"
      }
    }
  }

  provisioner "local-exec" {
    command = var.run_provisioner ? "gh repo view ${self.name} --web" : "echo 'Skip repo view'"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ${self.name}"
  }
}

resource "terraform_data" "repo-clone" {
  for_each   = var.repos
  depends_on = [github_repository_file.main, github_repository_file.readme]

  provisioner "local-exec" {
    command = var.run_provisioner ? "gh repo clone ${github_repository.tf_repo[each.key].name}" : "echo 'Skip clone'"
  }
}

resource "github_repository_file" "readme" {
  for_each   = var.repos
  repository = github_repository.tf_repo[each.key].name
  branch     = "main"
  file       = "README.md"
  content = templatefile("${path.module}/templates/readme.tftpl", {
    env        = var.env,
    lang       = each.value.lang,
    repo       = each.key
    authorname = data.github_user.current.name
  })
  overwrite_on_create = true
}

resource "github_repository_file" "main" {
  for_each            = var.repos
  repository          = github_repository.tf_repo[each.key].name
  branch              = "main"
  file                = each.value.filename
  content             = "# Hello ${each.value.lang}!"
  overwrite_on_create = true
  lifecycle {
    ignore_changes = [
      content,
    ]
  }
}

# moved {
#     from = github_repository_file.index
#     to = github_repository_file.main
# }
