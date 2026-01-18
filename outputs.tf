output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns_name" {
  value = module.alb.lb_dns_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "frontend_website_endpoint" {
  value = module.frontend.website_endpoint
}

output "nameservers" {
  value = "Check AWS Console for Route 53 Nameservers for ${var.domain_name}"
}
