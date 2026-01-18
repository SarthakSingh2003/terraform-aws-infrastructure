variable "bucket_name" {
  description = "Name of the S3 bucket for the frontend"
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
