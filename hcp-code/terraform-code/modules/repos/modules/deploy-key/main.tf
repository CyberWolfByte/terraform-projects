variable "repo_name" {
  description = "Name of the repository that requires key"
  type        = string
}

resource "tls_private_key" "thing" {
  algorithm = "ED25519"
}

resource "github_repository_deploy_key" "thing" {
  title      = "${var.repo_name}-key"
  repository = var.repo_name
  key        = tls_private_key.thing.public_key_openssh
  read_only  = false
}
resource "local_file" "thing" {
  content  = tls_private_key.thing.private_key_openssh
  filename = "${path.cwd}/${github_repository_deploy_key.thing.title}.pem"
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${self.filename}"
  }
}