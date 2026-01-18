output "cluster_id" {
  description = "ID of the ECS Cluster"
  value       = aws_ecs_cluster.main.id
}

output "service_name" {
  description = "Name of the ECS Service"
  value       = aws_ecs_service.main.name
}

output "service_security_group_id" {
  description = "Security Group ID of the ECS Service"
  value       = aws_security_group.ecs_service.id
}
