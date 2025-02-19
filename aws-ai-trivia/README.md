# AWS Terraform AI Trivia App

This project automates the deployment of an AI-powered trivia application using **Terraform**, **AWS ECS**, and **OpenAI API**. It provisions a scalable infrastructure with a frontend UI served by NGINX and a backend API that generates trivia questions using OpenAI’s GPT models. The project ensures cost control via AWS Budgets and implements security best practices through IAM and Secrets Manager.

## Acknowledgments

This project is based on [More Than Certified](https://github.com/morethancertified) by [Derek Morgan](https://github.com/mtcderek). We thank them for their contributions to the Terraform learning community.

## Features
- **Automated AWS Infrastructure**: Deploys ECS-based backend and frontend using Terraform.
- **AI-Driven Trivia API**: Generates trivia questions using OpenAI’s GPT models.
- **GitHub Codespaces Integration**: Enables quick setup and authentication within GitHub Codespaces.
- **AWS Cost Management**: Implements budgets and alerts to prevent overspending.
- **Secure Credential Management**: Uses AWS Secrets Manager for API keys and IAM for access control.
- **Path-based Routing**: Routes frontend and backend traffic through an Application Load Balancer.

## Prerequisites
- **Terraform**: v1.3+ installed.
- - **GitHub Codespaces**: Built and tested on Github Codespaces.
- **AWS CLI**: Configured with credentials.
- **Docker & Docker Compose**: Required for containerized deployment.
- **OpenAI API Key**: Needed for backend AI functionalities.

## Installation
### 1. GitHub & Codespaces Setup
- **Create a Codespace** within GitHub for cloud-based development.
- **Authenticate with GitHub** using a Personal Access Token (PAT) or OAuth.
- **Store authentication commands in a startup script**:

  ```bash
  nano ~/github-login.sh
  ```

- **Use the provided `github-login.sh` script from this repo**.
- **Automatically run the GitHub login script at shell startup**:

  ```bash
  nano ~/.bashrc
  ```

  Append the following line:

  ```bash
  source ~/github-login.sh
  ```

### 2. AWS Account Setup
- **AWS Budgets and Cost Management**:
  - Set up a monthly budget (e.g., $10) to monitor Terraform costs.
  - Configure alerting to prevent overspending.

- **AWS IAM Setup**:
  - Create an IAM user named e.g. `cwb-tf-user` under **AdminGroup**.
  - Assign **AdministratorAccess** permissions.
  - Generate an **AWS Access Key** named `cwb-tf-key` for **CLI use only**.

- **GitHub Codespaces AWS Credentials**:
  - Store AWS credentials as **GitHub repository secrets**.
  - Navigate to **Settings > Secrets and variables > Codespaces > Repository secrets**.
  - Add the following secrets:

    ```text
    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    ```

- **Validate AWS Credentials in GitHub Codespaces**:

  ```bash
  aws sts get-caller-identity
  ```

### 3. Generate an OpenAI API Key

- Visit [OpenAI API](https://platform.openai.com/signup/) and create an account.
- Navigate to [API Keys](https://platform.openai.com/api-keys/).
- Click **"Create new secret key"** and copy the generated key.

### 4. Store API Key in AWS Secrets Manager

- Store the OpenAI API Key securely:

  ```bash
  aws secretsmanager create-secret --region us-east-1 --name OPENAI_API_KEY --secret-string "<OPEN_AI_API_KEY>"
  ```

- Verify the stored secret:

  ```bash
  aws secretsmanager get-secret-value --secret-id OPENAI_API_KEY --region us-east-1
  ```

### 5. Deploy the AWS Infrastructure

- **Ensure that a dedicated S3 bucket exists before configuring the Terraform backend**:

  ```bash
  aws s3api create-bucket --bucket <BUCKET_NAME> --region us-east-1
  ```

- **Verify that the new S3 bucket was successfully created**:

  ```bash
  aws s3 ls | grep <BUCKET_NAME>
  ```

- **Enable S3 versioning to track changes to the Terraform state**:

  ```bash
  aws s3api put-bucket-versioning --bucket <BUCKET_NAME> --versioning-configuration Status=Enabled
  ```

## Usage

Clone the repository and initialize Terraform:

```bash
git clone https://github.com/CyberWolfByte/terraform-projects/aws-ai-trivia.git
cd aws-ai-trivia
terraform init
```

- **Deploy Terraform infrastructure**:

  ```bash
  terraform validate
  terraform plan
  terraform apply -auto-approve
  ```

### 6. Retrieve and Access the Application

- **Retrieve the ALB DNS name from Terraform output**

- **Access the application via the ALB DNS name**:

  ```bash
  Example: http://cwb-ecs-lb-1353976101.us-east-1.elb.amazonaws.com
  ```

  *It may take a few minutes for the DNS name to propagate. If necessary, open the link in an incognito browser.*

## How It Works

1. **GitHub Codespaces Setup**:
   - Configures GitHub authentication with a **startup script**.
   - Stores **AWS credentials securely** as repository secrets.

2. **AWS Infrastructure**:
   - Provisions **ECS clusters** for frontend (NGINX) and backend (Flask API).
   - Uses **ALB for routing** traffic between UI and API.
   - Stores Terraform state in **S3 with versioning**.
   - Manages secrets using **AWS Secrets Manager**.

3. **Application Deployment**:
   - **Frontend (NGINX)** serves `index.html` with dynamic backend integration.
   - **Backend (Flask API)** generates AI-driven trivia questions.
   - **ECS Task Definitions** dynamically inject environment variables.

## Output Example

Visiting the ALB URL should display the trivia UI.


## Contributing

If you have an idea for improvement or wish to collaborate, feel free to contribute.
