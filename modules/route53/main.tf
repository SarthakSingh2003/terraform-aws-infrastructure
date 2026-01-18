# Hosted Zone (Data source if using existing, or resource if creating new)
# Assuming creating new for this module as per request "What to include: Hosted zone"
resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = merge(
    var.common_tags,
    {
      Name = "${var.domain_name}-zone"
    }
  )
}

# DNS Record for ACM Validation
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in var.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
}

# Alias Record for ALB
resource "aws_route53_record" "alb_alias" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name # root domain
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
