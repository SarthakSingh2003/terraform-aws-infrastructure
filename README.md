# Terraform AWS Infrastructure

A modular Terraform infrastructure project for deploying AWS resources including VPC, EC2, S3, and IAM.

## 📁 Project Structure

```
terraform-aws-infra/
│
├── main.tf                 # Main configuration integrating all modules
├── provider.tf             # AWS provider configuration
├── variables.tf            # Root-level input variables
├── outputs.tf              # Root-level outputs
├── terraform.tfvars        # Variable values (customize this)
│
└── modules/
    ├── vpc/                # VPC module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── ec2/                # EC2 module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── s3/                 # S3 module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── iam/                # IAM module
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## 🚀 Features

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

## 📋 Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- AWS CLI configured with appropriate credentials
- An AWS account with necessary permissions
- An existing SSH key pair in AWS (for EC2 instance access)

## 🛠️ Configuration

### 1. Update `terraform.tfvars`

Before deploying, update the following values in `terraform.tfvars`:

```hcl
# AWS Configuration
aws_region  = "us-east-1"  # Your preferred region
environment = "dev"

# EC2 Configuration
ec2_ami_id   = "ami-xxxxxxxxx"      # Update with your region's AMI
ec2_key_name = "your-key-pair-name" # Your existing key pair

# S3 Configuration
s3_bucket_name = "unique-bucket-name-12345" # Must be globally unique
```

### 2. Find the Right AMI

To find the latest Amazon Linux 2023 AMI for your region:

```bash
aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=al2023-ami-2023*" "Name=architecture,Values=x86_64" \
  --query 'sort_by(Images, &CreationDate)[-1].[ImageId,Name,CreationDate]' \
  --output table
```

## 🚀 Deployment

### Step 1: Initialize Terraform

```bash
cd c:\Terraform-Infra
terraform init
```

This will download the required AWS provider plugins.

### Step 2: Validate Configuration

```bash
terraform validate
```

### Step 3: Preview Changes

```bash
terraform plan
```

Review the planned infrastructure changes carefully.

### Step 4: Apply Configuration

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

### Step 5: View Outputs

After successful deployment, Terraform will display output values:

```bash
terraform output
```

## 📊 Outputs

The configuration provides the following outputs:

- **VPC Information**: VPC ID, subnet IDs
- **EC2 Details**: Instance ID, public IP, private IP
- **S3 Information**: Bucket name, bucket ARN
- **IAM Details**: Role ARN, instance profile name

## 🔧 Customization

### Adjust VPC CIDR Blocks

Edit `variables.tf` or `terraform.tfvars`:

```hcl
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
```

### Modify EC2 Instance Type

```hcl
ec2_instance_type = "t3.small"
```

### Configure Security Group Rules

Edit `ec2_ingress_rules` in `terraform.tfvars` to customize allowed traffic.

### Enable S3 Lifecycle Rules

```hcl
s3_enable_lifecycle_rules = true
```

## 🔐 Security Best Practices

This infrastructure implements several security best practices:

- ✅ EBS volumes are encrypted by default
- ✅ S3 buckets block public access
- ✅ IMDSv2 is enforced on EC2 instances
- ✅ NAT Gateway provides secure outbound internet for private subnets
- ✅ IAM follows least privilege principle
- ✅ Security groups are restrictive (customize as needed)

> ⚠️ **Important**: Update the SSH security group rule to restrict access to your IP address instead of `0.0.0.0/0` in production.

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy
```

Type `yes` when prompted to confirm resource deletion.

## 📝 Notes

- **State Management**: For production use, configure remote state backend (S3 + DynamoDB) in `provider.tf`
- **Cost Optimization**: NAT Gateway incurs hourly charges. Set `enable_nat_gateway = false` if not needed
- **S3 Bucket Names**: Must be globally unique across all AWS accounts
- **Multi-Region**: Update `availability_zones` to match your chosen AWS region

## 🤝 Contributing

Feel free to customize the modules based on your specific requirements. Each module is independent and can be modified without affecting others.

## 📄 License

This project is provided as-is for educational and development purposes.
