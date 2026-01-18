variable "identifier" {
  description = "Identifier for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block to allow access from (optional)"
  type        = string
  default     = null
}

variable "app_security_group_id" {
  description = "Security Group ID of the application that needs access (optional)"
  type        = string
  default     = null
}

variable "common_tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
