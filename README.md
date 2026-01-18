# Terraform AWS Infrastructure

A modular Terraform infrastructure project for deploying AWS resources including VPC, EC2, S3, and IAM.

## Project Structure

terraform-aws-infra/
│
├── main.tf # Main configuration integrating all modules
├── provider.tf # AWS provider configuration
├── variables.tf # Root-level input variables
├── outputs.tf # Root-level outputs
├── terraform.tfvars # Variable values (customize this)
│
└── modules/
├── vpc/ # VPC module
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf
│
├── ec2/ # EC2 module
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf
│
├── s3/ # S3 module
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf
│
└── iam/ # IAM module
├── main.tf
├── variables.tf
└── outputs.tf


## Features

### VPC Module
- VPC with configurable CIDR block
- Public and private subnets across multiple availability zones
- Internet Gateway for public internet access
- NAT Gateway for private subnet outbound connectivity
- Route tables and associations

### EC2 Module
- EC2 instances with customizable instance types
- Security groups with configurable ingress rules
- IAM instance profile integration
- EBS encryption enabled by default
- IMDSv2 enforcement for enhanced security

### S3 Module
- S3 buckets with versioning support
- Server-side encryption (AES256 or KMS)
- Public access blocking by default
- Optional lifecycle rules for cost optimization
- Optional bucket logging

### IAM Module
- IAM role for EC2 instances
- S3 access policies
- CloudWatch Logs policies
- AWS Systems Manager (SSM) access
- Instance profiles for EC2

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- An AWS account with necessary permissions
- An existing SSH key pair in AWS (for EC2 instance access)

## Configuration

### 1. Update `terraform.tfvars`

```hcl
aws_region  = "us-east-1"
environment = "dev"

ec2_ami_id   = "ami-xxxxxxxxx"
ec2_key_name = "your-key-pair-name"

s3_bucket_name = "unique-bucket-name-12345"
Deployment
terraform init
terraform validate
terraform plan
terraform apply
Outputs
VPC ID and subnet IDs

EC2 instance ID and IP addresses

S3 bucket name and ARN

IAM role and instance profile details

Security Best Practices
EBS encryption enabled

S3 public access blocked

IMDSv2 enforced

Least-privilege IAM policies

Important: Restrict SSH access to your IP instead of 0.0.0.0/0 in production.

Cleanup
terraform destroy
Notes
Use S3 + DynamoDB backend for production

NAT Gateway incurs cost

S3 bucket names must be globally unique

Contributing
Feel free to customize the modules based on your requirements.

License
This project is provided as-is for educational purposes.