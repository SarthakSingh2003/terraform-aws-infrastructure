variable "environment" {
  description = "Environment name"
  type        = string
}

variable "enable_s3_access" {
  description = "Enable S3 access policy"
  type        = bool
  default     = true
}

variable "s3_bucket_arns" {
  description = "List of S3 bucket ARNs to grant access to"
  type        = list(string)
  default     = ["arn:aws:s3:::*"]
}

variable "enable_cloudwatch_logs" {
  description = "Enable CloudWatch Logs policy"
  type        = bool
  default     = true
}

variable "enable_ssm" {
  description = "Enable AWS Systems Manager access"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
