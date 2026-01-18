output "certificate_arn" {
  description = "ARN of the validated certificate"
  value       = aws_acm_certificate.main.arn
}

output "domain_validation_options" {
  description = "Domain validation options for Route53 record creation"
  value       = aws_acm_certificate.main.domain_validation_options
}
