output "clone-urls" {
  value = { for i in github_repository.tf_repo : i.name => {
    ssh-clone-url  = i.ssh_clone_url,
    http-clone-url = i.http_clone_url,
    pages-url      = try(i.pages[0].html_url, "no page")
    }
  }
  description = "Repository Names and URL"
  sensitive   = false
}

# output "varsource" {
#   value       = var.varsource
#   description = "Source being used to source variable definition."
# }