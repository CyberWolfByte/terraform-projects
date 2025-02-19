# Providers
terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.40"
    }
  }
}

# GitHub Provider: Used for managing GitHub resources (e.g., repositories, teams)
provider "github" {
  owner = "<YOUR_GITHUB_ACCOUNT>" # GitHub organization or user name
}

# NOTE: Use this version if NOT using TF Cloud Org-Level Variable Sets for authentication
# provider "github" {
#   token = var.github_token  # Explicitly pass GitHub token
#   owner = "<YOUR_GITHUB_ACCOUNT>" # GitHub organization or user name
# }

# ==========================
# Input Variables
# ==========================
variable "github_token" {
  description = "GitHub token used for authentication"
  type        = string
  sensitive   = true
}

variable "tfe_token" {
  description = "Terraform Cloud API token for authentication"
  type        = string
  sensitive   = true
}

# Terraform Cloud (`tfe`) Provider Configuration
provider "tfe" {
  hostname = "app.terraform.io"
  token    = var.tfe_token # Authentication token for Terraform Cloud
}

# Retrieve Terraform Cloud Organization details
data "tfe_organization" "this" {
  name = "CWB-TF-2025" # Replace with your Terraform Cloud organization name
}

# ==========================
# GitHub OAuth Client (For Terraform Cloud VCS Integration)
# ==========================
resource "tfe_oauth_client" "this" {
  name                = "cwb-github-oauth-client"
  organization        = data.tfe_organization.this.name
  api_url             = "https://api.github.com"
  http_url            = "https://github.com"
  oauth_token         = var.github_token # Token used for GitHub authentication
  service_provider    = "github"
  organization_scoped = true
}

# ==========================
# Terraform Cloud Project
# ==========================
resource "tfe_project" "this" {
  name         = "cwb-project"
  organization = data.tfe_organization.this.name
}

# Associate the GitHub OAuth client with the Terraform Cloud Project
resource "tfe_project_oauth_client" "this" {
  project_id      = tfe_project.this.id
  oauth_client_id = tfe_oauth_client.this.id
}

# ==========================
# Workspaces (Terraform Cloud Environments)
# ==========================
# cwb_repos Workspace (Used for managing repositories)
resource "tfe_workspace" "cwb_repos" {
  name         = "cwb-repos"
  organization = data.tfe_organization.this.name
  project_id   = tfe_project.this.id

  working_directory     = "hcp-code/terraform-code/modules/repos"
  auto_apply            = true
  file_triggers_enabled = true
  trigger_patterns      = ["**/repos/**/*"]

  vcs_repo {
    identifier         = "CyberWolfByte/terraform-poc" # Your GitHub repository
    branch             = "cicd"
    ingress_submodules = false
    oauth_token_id     = tfe_oauth_client.this.oauth_token_id
  }
}

# cwb_info_page Workspace (Depends on `cwb_repos`)
resource "tfe_workspace" "cwb_info_page" {
  depends_on   = [tfe_workspace.cwb_repos] # Ensures repos workspace is created first
  name         = "cwb-info-page"
  organization = data.tfe_organization.this.name
  project_id   = tfe_project.this.id

  working_directory      = "hcp-code/terraform-code/modules/info-page"
  auto_apply             = false
  file_triggers_enabled  = true
  trigger_patterns       = ["**/info-page/**/*"]
  auto_apply_run_trigger = true

  vcs_repo {
    identifier         = "CyberWolfByte/terraform-poc" # Your GitHub repository
    branch             = "cicd"
    ingress_submodules = false
    oauth_token_id     = tfe_oauth_client.this.oauth_token_id
  }
}

# ==========================
# Remote State Access Between Workspaces
# ==========================
resource "tfe_workspace_settings" "this" {
  workspace_id              = tfe_workspace.cwb_repos.id
  remote_state_consumer_ids = [tfe_workspace.cwb_info_page.id]
}

# ==========================
# Workspace Run Management (For Controlled Destruction)
# ==========================
resource "tfe_workspace_run" "cwb_repos" {
  workspace_id = tfe_workspace.cwb_repos.id

  destroy {
    manual_confirm = false
    wait_for_run   = true
  }
}

resource "tfe_workspace_run" "cwb_info_page" {
  workspace_id = tfe_workspace.cwb_info_page.id
  depends_on   = [tfe_workspace_run.cwb_repos, tfe_workspace_settings.this]

  destroy {
    manual_confirm = false
    wait_for_run   = true
  }
}

# ==========================
# Alternative Setup Without TF Cloud Org-Level Variable Sets
# ==========================
# If not using Terraform Cloud Org-Level Variable Sets, uncomment these sections

# Create Variable Set to Store GitHub Token in Terraform Cloud
# resource "tfe_variable_set" "this" {
#   name              = "GitHub Token Set"
#   description       = "Stores GitHub token for deployments"
#   organization      = data.tfe_organization.this.name
#   parent_project_id = tfe_project.this.id
#   priority          = true
# }

# Store GitHub Token in Terraform Cloud Variable Set
# resource "tfe_variable" "cwb_repos_github_token" {
#   key             = "GITHUB_TOKEN"
#   value           = var.github_token
#   category        = "env"
#   sensitive       = true
#   variable_set_id = tfe_variable_set.this.id
#   depends_on      = [tfe_variable_set.this]
# }

# Link Variable Set to Terraform Cloud Project
# resource "tfe_project_variable_set" "this" {
#   project_id      = tfe_project.this.id
#   variable_set_id = tfe_variable_set.this.id
# }

# ==========================
# Run Triggers (For Automatic Execution)
# ==========================
# Ensures `cwb_repos` changes automatically trigger updates in `cwb_info_page`
resource "tfe_run_trigger" "cwb_repos_to_cwb_info_page" {
  sourceable_id = tfe_workspace.cwb_repos.id
  workspace_id  = tfe_workspace.cwb_info_page.id
}