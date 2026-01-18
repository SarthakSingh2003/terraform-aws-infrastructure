output "zone_id" {
  description = "ID of the Hosted Zone"
  value       = aws_route53_zone.main.zone_id
}

output "validation_record_fqdns" {
  description = "List of FQDNs for validation records"
  value       = [for record in aws_route53_record.cert_validation : record.fqdn]
}
