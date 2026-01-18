output "db_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.main.endpoint
}

output "db_port" {
  description = "The database port"
  value       = aws_db_instance.main.port
}
