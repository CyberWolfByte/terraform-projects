# GitOps Terraform Cloud Automation

This project automates the provisioning of Terraform Cloud (TFE) workspaces, GitHub repositories, and authentication via Terraform. It follows a **GitOps** approach, enabling infrastructure as code (IaC) automation with secure remote state management and role-based access control.

## Acknowledgments

This project is based on [More Than Certified](https://github.com/morethancertified) by [Derek Morgan](https://github.com/mtcderek). We appreciate their contributions to Terraform automation.

## Features

- **GitHub Pages Portfolio**: Deploys a landing page using GitHub Pages and a dynamic `index.md` template.
- **Automated Terraform Cloud (TFE) Setup**: Manages workspaces, projects, and authentication via Terraform.
- **GitOps Workflow**: Implements infrastructure automation using Terraform Cloud and GitHub integration.
- **Remote State Management**: Secure state sharing with Terraform Cloud.
- **Role-Based Access Control**: Ensures granular permissions within Terraform Cloud.

## Prerequisites

- **Terraform Version**: v1.3+ installed.
- **GitHub CLI**: Required for repository management.
- **Terraform Cloud Account**: Necessary for TFE workspace automation.
- **GitHub API Token**: Required for repository automation.

## Installation

Clone the repository and initialize Terraform:

```bash
git clone https://github.com/CyberWolfByte/terraform-projects.git
cd hcp-code
terraform init
```

## Usage

### 1. Generate a GitHub API Token

- Go to [GitHub Developer Settings](https://github.com/settings/tokens).
- Click **Generate new token** (classic mode).
- **Set the name:** `<GITHUB_TOKEN_NAME>` (e.g., `hcp-code-gh-token`).
- **Set expiration:** `<TIMEFRAME>` (e.g., 30 days).
- **Select scopes:** `repo`, `user`, `delete_repo`.
- Save the token securely.

### 2. Generate a Terraform Cloud API Token

- Go to [Terraform Cloud Settings](https://app.terraform.io/app/settings/tokens).
- Click **Create an API token**.
- **Set the description:** `<HCP_TOKEN_NAME>` (e.g., `hcp-code-demo`).
- **Set expiration:** `<TIMEFRAME>` (e.g., 30 days).
- Save the token securely.

### 3. Create a Variable Set in Terraform Cloud

- Navigate to your Terraform Cloud organization (e.g., `CWB-TF-2025`).
- Go to **Settings → Variable Sets**.
- Click **Create Variable Set**.
- **Set Name:** `GitHub Organization Token`.
- **Set Description:** `Token required for automation`.
- **Scope:** Apply to all projects and workspaces.
- **Add Environment Variables** (mark as **Sensitive**):
  - **Key:** `GITHUB_TOKEN`
  - **Value:** `<GITHUB_GENERATED_API_TOKEN>`

### 4. Create a Dedicated GitHub Repository and Upload Project

- **Create a new repository** in your GitHub account.
  - Visit [GitHub](https://github.com/new) and create a repository.
  - **Repository Name:** `<YOUR_REPO_NAME>` (e.g., `hcp-code`).
  - Set it as **Private** or **Public**.
  - Do not initialize with a README, `.gitignore`, or license.
  - Upload the project to GitHub.

  ```
- **Ensure Terraform Cloud has access** to the repository for automation.

### 5. Configure Terraform for GitOps Automation

Modify the placeholders in `hcp-code/main.tf` to reflect your Terraform Cloud and GitHub accounts.

### 6. Export Tokens for Local Execution

```bash
export GITHUB_TOKEN="your-github-token"
export TF_VAR_github_token="<GITHUB_TOKEN_NAME>"
export TF_VAR_tfe_token="<TFE_TOKEN_NAME>"
```

### 7. Initialize and Deploy Infrastructure

```bash
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

## How It Works

1. **GitOps Workflow**:
   - Automates GitHub repository provisioning and Terraform Cloud workspace creation.
   - Uses a Terraform `index.md` template to dynamically generate a portfolio site.

2. **Terraform Cloud Automation**:
   - Creates and manages Terraform Enterprise (TFE) projects and workspaces.
   - Integrates GitHub as a **VCS Provider** for automated repository deployments.
   - Uses **Variable Sets** for secure API token management.

3. **Remote State Management**:
   - Terraform Cloud securely stores the state file.
   - Workspaces manage configurations using GitHub repositories.

## Output Example

After deployment, Terraform outputs the Terraform Cloud workspace details:

## Contributing

If you have an idea for improvement or wish to collaborate, feel free to contribute.

---
