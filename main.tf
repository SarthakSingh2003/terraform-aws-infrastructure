# Local Values
locals {
  common_tags = merge(
    var.default_tags,
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  environment          = var.environment
  enable_nat_gateway   = var.enable_nat_gateway
  common_tags          = local.common_tags
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  environment            = var.environment
  enable_s3_access       = true
  s3_bucket_arns         = [module.s3.bucket_arn, "${module.s3.bucket_arn}/*"]
  enable_cloudwatch_logs = true
  enable_ssm             = true
  common_tags            = local.common_tags
}

# S3 Module
module "s3" {
  source = "./modules/s3"

  bucket_name            = var.s3_bucket_name
  enable_versioning      = var.s3_enable_versioning
  enable_lifecycle_rules = var.s3_enable_lifecycle_rules
  common_tags            = local.common_tags
}

# EC2 Module
module "ec2" {
  source = "./modules/ec2"

  environment          = var.environment
  instance_name        = var.ec2_instance_name
  ami_id               = var.ec2_ami_id
  instance_type        = var.ec2_instance_type
  key_name             = var.ec2_key_name
  subnet_id            = module.vpc.public_subnet_ids[0]
  vpc_id               = module.vpc.vpc_id
  iam_instance_profile = module.iam.instance_profile_name
  ingress_rules        = var.ec2_ingress_rules
  common_tags          = local.common_tags

  depends_on = [module.iam, module.vpc]
}
