variable "cluster_id" {
  description = "Cluster ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR to allow ingress from"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the cache"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
