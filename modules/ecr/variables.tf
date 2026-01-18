variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
