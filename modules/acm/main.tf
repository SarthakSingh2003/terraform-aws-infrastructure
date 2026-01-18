# ACM Certificate
resource "aws_acm_certificate" "main" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.domain_name}-cert"
    }
  )
}

# Certificate Validation
# Note: This resource waits for the validation record to be created in Route53 and verified.
# resource "aws_acm_certificate_validation" "main" {
#   certificate_arn         = aws_acm_certificate.main.arn
#   validation_record_fqdns = [for record in var.validation_record_fqdns : record]
# }
