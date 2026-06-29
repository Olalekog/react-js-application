# AWS Multi-Account 3-Tier Application Deployment

This project deploys a secure, scalable, multi-account AWS 3-tier application using **Terraform**, **GitHub Actions**, **Docker**, **EC2 Auto Scaling Groups**, **Application Load Balancers**, **Amazon RDS MySQL**, **AWS Secrets Manager**, **SSM Parameter Store**, and **KMS encryption**.

The application has:

- **Frontend:** React.js packaged as a Docker image and served by Nginx
- **Backend:** Python FastAPI packaged as a Docker image
- **Database:** Amazon RDS MySQL with RDS-managed password stored in AWS Secrets Manager
- **Infrastructure:** Terraform modules deployed through GitHub Actions
- **Account model:** Tooling, Dev, UAT, and Production AWS accounts

---

## Architecture Diagram

![Architecture Diagram](assets/architecture-diagram.png)

---

## Deployment Flow Diagram

![Deployment Flow Diagram](assets/deployment-flow-diagram.png)

---

## Application Request Flow Diagram

![Application Request Flow](assets/application-request-flow.png)

---

## High-Level Architecture

```text
GitHub Actions
  |
  | OIDC authentication
  v
Tooling Account
  |
  | Central Terraform state
  | Bootstrap role
  | SSM SecureString deploy role ARN parameters
  v
Dev / UAT / Production Accounts
  |
  | Environment deploy roles
  | ECR repositories
  | VPC, ALB, ASG, RDS, KMS, Secrets Manager
  v
3-Tier Application
```

---

## Project Purpose

The purpose of this project is to demonstrate how to deploy a production-style AWS 3-tier application using reusable Infrastructure as Code and CI/CD automation.

The project supports different environments across different AWS accounts:

| Environment | Branch | AWS Account | Terraform Folder | State File |
|---|---|---|---|---|
| Dev | `develop` | Dev account | `terraform/environments/dev` | `three-tier-app/dev/terraform.tfstate` |
| UAT | `uat` | UAT account | `terraform/environments/uat` | `three-tier-app/uat/terraform.tfstate` |
| Production | `main` | Production account | `terraform/environments/production` | `three-tier-app/production/terraform.tfstate` |

---

## Application Architecture

The application follows a 3-tier design.

### 1. Presentation Tier

The presentation tier runs the React.js frontend.

It is deployed as a Docker container on EC2 instances inside an Auto Scaling Group. Nginx serves the React static files and proxies API requests to the backend through the internal Application Load Balancer.

Main components:

- React.js
- Nginx
- Docker
- EC2 Auto Scaling Group
- Public Application Load Balancer

### 2. Application Tier

The application tier runs the Python FastAPI backend.

It is deployed as a Docker container on EC2 instances inside a separate Auto Scaling Group. The backend is private and is only reachable through the internal Application Load Balancer.

Main components:

- Python FastAPI
- Gunicorn/Uvicorn
- Docker
- EC2 Auto Scaling Group
- Internal Application Load Balancer
- IAM instance role
- AWS Secrets Manager integration

### 3. Database Tier

The database tier uses Amazon RDS for MySQL.

The database is deployed in private database subnets and is not publicly accessible. RDS generates and manages the master password in AWS Secrets Manager.

Main components:

- Amazon RDS MySQL
- Private DB subnet group
- RDS-managed Secrets Manager password
- KMS encryption
- Automated backups
- Multi-AZ support for production

---

## Request Flow

When a user submits data from the frontend, the request follows this path:

```text
User Browser
  |
  v
Public Application Load Balancer
  |
  v
Frontend EC2 ASG
React.js + Nginx container
  |
  | /api/* request proxy
  v
Internal Application Load Balancer
  |
  v
Backend EC2 ASG
FastAPI container
  |
  | reads database secret from AWS Secrets Manager
  v
Amazon RDS MySQL
```

The frontend never connects directly to the database. All database reads and writes go through the backend API.

---

## Database Write Flow

When the frontend adds a new user:

1. User enters data in the React form.
2. React sends a `POST /api/users` request.
3. Nginx proxies the request to the internal backend ALB.
4. FastAPI validates the request using Pydantic.
5. FastAPI reads the RDS-managed database secret from AWS Secrets Manager.
6. FastAPI connects to RDS MySQL.
7. FastAPI inserts the record into the `users` table.
8. FastAPI returns a success response to the frontend.

Example API endpoint:

```text
POST /api/users
```

Example request body:

```json
{
  "name": "John Doe",
  "email": "john@example.com"
}
```

---

## FastAPI Startup Database Initialization

The backend initializes the database table during application startup.

This is useful for dev and learning environments. For production, a dedicated migration tool such as Alembic or Flyway is recommended.

The backend creates this table if it does not already exist:

```sql
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## Multi-Account Design

This project separates responsibilities across AWS accounts.

### Tooling Account

The tooling account owns shared CI/CD and Terraform backend resources:

- Terraform state S3 bucket
- DynamoDB lock table
- KMS key for Terraform state encryption
- GitHub OIDC provider
- GitHub bootstrap role
- SSM SecureString parameters containing deploy role ARNs

### Dev Account

The dev account owns the dev application stack:

- Dev deploy role
- Dev ECR repositories
- Dev VPC and subnets
- Dev ALBs
- Dev EC2 ASGs
- Dev RDS MySQL
- Dev KMS key
- Dev Secrets Manager secret

### UAT Account

The UAT account owns the UAT application stack:

- UAT deploy role
- UAT ECR repositories
- UAT VPC and subnets
- UAT ALBs
- UAT EC2 ASGs
- UAT RDS MySQL
- UAT KMS key
- UAT Secrets Manager secret

### Production Account

The production account owns the production application stack:

- Production deploy role
- Production ECR repositories
- Production VPC and subnets
- Production ALBs
- Production EC2 ASGs
- Production RDS MySQL
- Production KMS key
- Production Secrets Manager secret
- Production approval gates
- Production deletion protection
- Production Multi-AZ database configuration

---

## Repository Structure

```text
.
├── frontend/
│   ├── Dockerfile
│   ├── nginx.conf
│   ├── package.json
│   └── src/
│
├── backend/
│   ├── Dockerfile
│   ├── requirements.txt
│   └── main.py
│
├── terraform/
│   ├── tooling/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── bootstrap/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── modules/
│   │   ├── network/
│   │   ├── security-groups/
│   │   ├── alb/
│   │   ├── asg/
│   │   ├── rds/
│   │   ├── kms/
│   │   ├── ecr/
│   │   ├── iam/
│   │   └── ssm/
│   │
│   └── environments/
│       ├── dev/
│       ├── uat/
│       └── production/
│
├── .github/
│   └── workflows/
│       ├── tooling-foundation.yml
│       ├── bootstrap-multi-account.yml
│       └── app-deploy.yml
│
├── assets/
│   ├── architecture-diagram.png
│   ├── deployment-flow-diagram.png
│   └── application-request-flow.png
│
└── README.md
```

---

## GitHub Actions Workflows

### 1. Tooling Foundation Workflow

File:

```text
.github/workflows/tooling-foundation.yml
```

Purpose:

Creates the central tooling foundation.

Creates:

- S3 bucket for Terraform remote state
- DynamoDB table for Terraform state locking
- KMS key for state encryption
- GitHub OIDC provider
- GitHub bootstrap role

This workflow runs first.

### 2. Bootstrap Multi-Account Workflow

File:

```text
.github/workflows/bootstrap-multi-account.yml
```

Purpose:

Creates required resources in dev, uat, and production accounts.

Creates:

- Dev deploy role
- UAT deploy role
- Production deploy role
- ECR repositories in each target account
- SSM SecureString parameters in the tooling account

### 3. App Deploy Workflow

File:

```text
.github/workflows/app-deploy.yml
```

Purpose:

Builds and deploys the application.

The workflow:

1. Resolves environment based on branch.
2. Assumes the tooling bootstrap role using GitHub OIDC.
3. Reads the target account deploy role ARN from SSM SecureString.
4. Assumes the target account deploy role.
5. Builds Docker images.
6. Pushes Docker images to ECR in the target account.
7. Runs Terraform using centralized state.
8. Deploys or updates the environment stack.

---

## Deployment Order

Run the project in this order:

```text
1. Tooling Foundation workflow
2. Bootstrap Multi-Account workflow
3. App Deploy workflow
```

---

## Step 1: Run Tooling Foundation Workflow

Before this workflow runs, add temporary AWS credentials for the tooling account.

GitHub Secrets:

```text
TOOLING_AWS_ACCESS_KEY_ID
TOOLING_AWS_SECRET_ACCESS_KEY
```

GitHub Variables:

```text
AWS_REGION
PROJECT_NAME
TOOLING_ACCOUNT_ID
GITHUB_ORG
GITHUB_REPO
TERRAFORM_VERSION
```

Run:

```text
Actions → Tooling Foundation → Run workflow → action=plan
```

Then run:

```text
Actions → Tooling Foundation → Run workflow → action=apply
```

After apply, copy the Terraform outputs into GitHub Variables:

```text
BOOTSTRAP_ROLE_ARN
TF_STATE_BUCKET
TF_LOCK_TABLE
TF_STATE_KMS_KEY_ID
```

Then delete the temporary tooling AWS secrets.

---

## Step 2: Run Bootstrap Multi-Account Workflow

Required GitHub Variables:

```text
AWS_REGION
PROJECT_NAME
TOOLING_ACCOUNT_ID
DEV_ACCOUNT_ID
UAT_ACCOUNT_ID
PRODUCTION_ACCOUNT_ID
BOOTSTRAP_ROLE_ARN
FRONTEND_REPOSITORY_NAME
BACKEND_REPOSITORY_NAME
TERRAFORM_VERSION
```

Run:

```text
Actions → Bootstrap Multi-Account → Run workflow → action=plan
```

Then run:

```text
Actions → Bootstrap Multi-Account → Run workflow → action=apply
```

This creates deploy roles and ECR repositories in the target accounts.

---

## Step 3: Deploy the App

The app workflow uses branch-based deployment.

| Branch | Environment | Target Account |
|---|---|---|
| `develop` | dev | Dev account |
| `uat` | uat | UAT account |
| `main` | production | Production account |

### Deploy Dev

```bash
git checkout -b develop
git add .
git commit -m "Deploy dev stack"
git push origin develop
```

### Deploy UAT

```bash
git checkout uat
git merge develop
git push origin uat
```

### Deploy Production

```bash
git checkout main
git merge uat
git push origin main
```

Production should use GitHub Environment approval before apply.

---

## Required GitHub Variables

```text
AWS_REGION=us-east-1
PROJECT_NAME=three-tier-app
TOOLING_ACCOUNT_ID=111111111111
DEV_ACCOUNT_ID=222222222222
UAT_ACCOUNT_ID=333333333333
PRODUCTION_ACCOUNT_ID=444444444444
GITHUB_ORG=your-github-username-or-org
GITHUB_REPO=your-repo-name
BOOTSTRAP_ROLE_ARN=arn:aws:iam::111111111111:role/three-tier-app-github-actions-bootstrap-role
TF_STATE_BUCKET=three-tier-app-terraform-state-111111111111
TF_LOCK_TABLE=three-tier-app-terraform-locks
TF_STATE_KMS_KEY_ID=alias/three-tier-app-tooling-state-kms
FRONTEND_REPOSITORY_NAME=react-frontend
BACKEND_REPOSITORY_NAME=fastapi-backend
TERRAFORM_VERSION=1.9.0
```

---

## Security Design

This project uses multiple security controls:

- GitHub OIDC instead of long-lived AWS keys after tooling bootstrap
- Centralized Terraform state encrypted with KMS
- DynamoDB state locking
- SSM SecureString for deploy role ARN parameters
- Least-privilege deploy roles per environment
- Environment-specific AWS accounts
- Private EC2 instances
- Private RDS database
- RDS-generated password stored in AWS Secrets Manager
- KMS encryption for RDS, EBS, ECR, logs, SSM, Secrets Manager, and state
- Security groups allowing only required traffic flows
- Production approval gate in GitHub Environments

---

## Network Design

Each application account deploys a separate VPC.

Typical subnet layout:

```text
VPC
├── Public subnets
│   └── Public Application Load Balancer
│
├── Private frontend subnets
│   └── Frontend EC2 Auto Scaling Group
│
├── Private backend subnets
│   └── Backend EC2 Auto Scaling Group
│
└── Private database subnets
    └── Amazon RDS MySQL
```

The database is never publicly accessible.

---

## Security Group Flow

```text
Internet
  |
  | 80/443
  v
Public ALB Security Group
  |
  | frontend port
  v
Frontend EC2 Security Group
  |
  | backend API port
  v
Internal ALB Security Group
  |
  | backend API port
  v
Backend EC2 Security Group
  |
  | 3306
  v
RDS MySQL Security Group
```

---

## Secrets Management

The database password is not stored in GitHub and is not passed as a Terraform variable.

RDS creates and manages the master password in Secrets Manager using:

```hcl
manage_master_user_password   = true
master_user_secret_kms_key_id = var.kms_key_arn
```

The backend receives only this environment variable:

```text
DB_SECRET_ARN
```

The backend EC2 instance role has permission to call:

```text
secretsmanager:GetSecretValue
kms:Decrypt
```

---

## Docker Images

The app workflow builds two Docker images:

```text
react-frontend
fastapi-backend
```

Images are pushed to ECR in the target account:

```text
<target-account-id>.dkr.ecr.<region>.amazonaws.com/react-frontend:<environment>-<git-sha>
<target-account-id>.dkr.ecr.<region>.amazonaws.com/fastapi-backend:<environment>-<git-sha>
```

Example:

```text
222222222222.dkr.ecr.us-east-1.amazonaws.com/react-frontend:dev-a1b2c3d
222222222222.dkr.ecr.us-east-1.amazonaws.com/fastapi-backend:dev-a1b2c3d
```

---

## Terraform State Strategy

Terraform state is centralized in the tooling account, but each environment has a separate state file.

```text
s3://three-tier-app-terraform-state-111111111111/three-tier-app/dev/terraform.tfstate
s3://three-tier-app-terraform-state-111111111111/three-tier-app/uat/terraform.tfstate
s3://three-tier-app-terraform-state-111111111111/three-tier-app/production/terraform.tfstate
```

This ensures that dev, uat, and production do not share the same state.

---

## Environment Differences

| Setting | Dev | UAT | Production |
|---|---|---|---|
| Instance size | Small | Medium | Larger |
| ASG desired capacity | 1 | 2 | 2+ |
| RDS size | Small | Medium | Production class |
| RDS Multi-AZ | No | Optional | Yes |
| Deletion protection | No | Optional | Yes |
| Approval gate | No | Optional | Required |
| Branch | `develop` | `uat` | `main` |

---

## Local Backend Requirements

The backend uses:

```text
fastapi
uvicorn[standard]
gunicorn
mysql-connector-python
boto3
pydantic[email]
```

The `pydantic[email]` dependency is required because the API uses `EmailStr` for email validation.

---

## Useful API Endpoints

```text
GET  /
GET  /health
GET  /api/users
POST /api/users
```

Example health check:

```bash
curl http://<public-alb-dns-name>/api/health
```

Example create user request:

```bash
curl -X POST http://<public-alb-dns-name>/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com"}'
```

---

## Operational Notes

- Run tooling first.
- Run bootstrap second.
- Deploy dev before uat.
- Deploy uat before production.
- Keep production protected with approval gates.
- Do not store database passwords in GitHub.
- Do not allow SSH from the internet.
- Use SSM Session Manager for EC2 access.
- Use immutable image tags based on Git SHA.
- Use separate AWS accounts for environment isolation.

---

## Final Summary

This project implements a secure AWS multi-account 3-tier application deployment platform. The tooling account provides centralized CI/CD trust and Terraform state. The bootstrap stack prepares each target account with deploy roles and ECR repositories. The app stack deploys the React frontend, FastAPI backend, and RDS MySQL database into dev, uat, and production accounts using reusable Terraform modules and GitHub Actions automation.
