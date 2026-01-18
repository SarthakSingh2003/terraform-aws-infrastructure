locals {
  common_tags = merge(
    var.default_tags,
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

# 1. VPC Module
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

# 2. IAM Module
module "iam" {
  source = "./modules/iam"

  environment            = var.environment
  enable_s3_access       = true
  s3_bucket_arns         = [module.s3.bucket_arn, "${module.s3.bucket_arn}/*"]
  enable_cloudwatch_logs = true
  enable_ssm             = true
  common_tags            = local.common_tags
}

# 3. S3 Module
module "s3" {
  source = "./modules/s3"

  bucket_name       = "${var.project_name}-${var.environment}-assets"
  enable_versioning = true
  common_tags       = local.common_tags
}

# 4. ECR Module
module "ecr" {
  source = "./modules/ecr"

  repository_name = "${var.project_name}-repo"
  common_tags     = local.common_tags
}

# 5. RDS Module
module "rds" {
  source = "./modules/rds"

  identifier            = "${var.project_name}-db"
  db_name               = "appdb"
  username              = var.db_username
  password              = var.db_password
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.private_subnet_ids
  vpc_cidr_block        = module.vpc.vpc_cidr
  app_security_group_id = module.ecs.service_security_group_id # Allow access from ECS
  common_tags           = local.common_tags
}

# 6. ECS Module (Initialized BEFORE RDS in code, but RDS depends on SG from here effectively or vice versa. 
# Actually RDS allows ingress from a specific SG ID. We can create ECS service SG in ECS module.
# To avoid cycle: RDS allows ingress from VPC CIDR or specific SG. 
# Let's pass ECS Service SG ID to RDS module variable.)
module "ecs" {
  source = "./modules/ecs"

  environment           = var.environment
  aws_region            = var.aws_region
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  alb_security_group_id = module.alb.security_group_id
  target_group_arn      = module.alb.target_group_arn
  execution_role_arn    = module.iam.ecs_execution_role_arn
  task_role_arn         = module.iam.ecs_task_role_arn
  container_image       = module.ecr.repository_url # Or var.app_image
  common_tags           = local.common_tags
}

# 7. ALB Module
module "alb" {
  source = "./modules/alb"

  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  common_tags       = local.common_tags
}

# 8. ACM Module
module "acm" {
  source = "./modules/acm"

  domain_name             = var.domain_name
  validation_record_fqdns = module.route53.validation_record_fqdns
  common_tags             = local.common_tags
}

# 9. Route53 Module
module "route53" {
  source = "./modules/route53"

  domain_name               = var.domain_name
  alb_dns_name              = module.alb.lb_dns_name
  alb_zone_id               = module.alb.lb_zone_id
  domain_validation_options = module.acm.domain_validation_options
  common_tags               = local.common_tags
}

# 10. Frontend Module
module "frontend" {
  source = "./modules/frontend"

  bucket_name = "${var.project_name}-${var.environment}-frontend"
  common_tags = local.common_tags
}

# 11. ElastiCache Module
module "elasticache" {
  source = "./modules/elasticache"

  cluster_id  = "${var.project_name}-cache"
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = module.vpc.vpc_cidr
  subnet_ids  = module.vpc.private_subnet_ids
  common_tags = local.common_tags
}
