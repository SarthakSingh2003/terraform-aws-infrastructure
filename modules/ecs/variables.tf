variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security Group ID of the ALB"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB Target Group"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the ECS Execution Role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the ECS Task Role"
  type        = string
}

variable "container_image" {
  description = "Docker image to run"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "Fargate CPU units"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Fargate Memory units"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of tasks to run"
  type        = number
  default     = 1
}

variable "common_tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
