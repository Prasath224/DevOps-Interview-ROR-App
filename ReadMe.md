![Deploy to AWS ECS](https://github.com/Prasath224/DevOps-Interview-ROR-App/actions/workflows/docker.yml/badge.svg)


# Ruby on Rails App Deployment on AWS ECS using Terraform

This project demonstrates a complete Infrastructure as Code (IaC) setup for deploying a Dockerized Ruby on Rails application on AWS ECS Fargate using Terraform. The infrastructure includes VPC, ECS, ALB, RDS, S3, and IAM roles following best practices.

---

## Components
- **Terraform Modules**:
  - `vpc`: Custom VPC with public and private subnets
  - `alb`: Application Load Balancer in public subnets
  - `ecs`: ECS Fargate Cluster, Task Definition, and Service
  - `rds`: PostgreSQL 13.3 in private subnets
  - `s3`: Bucket for file uploads
  - `iam`: IAM role for ECS task to access S3
  - `ecr`: Repository for Docker image

---

## Architecture Diagram
User
  │
  ▼
Application Load Balancer (Public Subnet)
  │
  ▼
ECS Fargate Service (Private Subnet)
  ├──▶ RDS (PostgreSQL)
  └──▶ S3 Bucket


---

## Deployment Instructions

## Prerequisites
- AWS CLI configured with appropriate IAM permissions
- Terraform CLI v1.6.6 or higher
- Docker
- GitHub Actions Secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`

1. Fork the Repository:
git clone https://github.com/Prasath224/DevOps-Interview-ROR-App.git
cd DevOps-Interview-ROR-App

2. Setup GitHub Actions Workflow (already included):
Builds Docker image
Pushes to ECR
Triggers Terraform deployment on push to main

3. Define Inputs (terraform.tfvars):

region           = "us-east-1"
s3_bucket_name   = "ror-app-upload-YOURNAME"
ecr_repo_name    = "ror-app"
db_name          = "appdb"
db_username      = "appuser"
db_password      = "AppSecurePass123"
app_image_url    = "<ECR_IMAGE_URL>"

Replace <ECR_IMAGE_URL> with the actual ECR URL printed from GitHub Actions output or ECR console.

4. Initialize Terraform:
cd terraform
terraform init

5. Apply Infrastructure:
terraform apply -auto-approve

6. Output:
After apply, you’ll get:

Load Balancer DNS to test the Rails app
ECS Cluster & Service details

## Testing the App
Once deployed, access: http://<alb_dns_name>
The Rails application should load successfully.

## Clean Up:
terraform destroy -auto-approve

