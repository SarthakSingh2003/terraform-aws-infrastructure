output "website_endpoint" {
  description = "Endpoint for the static website"
  value       = aws_s3_bucket_website_configuration.frontend.website_endpoint
}

output "bucket_name" {
  description = "Name of the bucket"
  value       = aws_s3_bucket.frontend.id
}
