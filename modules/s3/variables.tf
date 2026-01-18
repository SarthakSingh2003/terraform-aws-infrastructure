variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm (AES256 or aws:kms)"
  type        = string
  default     = "AES256"
}

variable "kms_master_key_id" {
  description = "KMS key ID for SSE-KMS encryption"
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Enable S3 Bucket Key for encryption"
  type        = bool
  default     = true
}

variable "block_public_acls" {
  description = "Block public ACLs"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public bucket policies"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public bucket policies"
  type        = bool
  default     = true
}

variable "enable_lifecycle_rules" {
  description = "Enable lifecycle rules"
  type        = bool
  default     = false
}

variable "transition_to_ia_days" {
  description = "Days before transitioning to IA storage class"
  type        = number
  default     = 30
}

variable "transition_to_glacier_days" {
  description = "Days before transitioning to Glacier storage class"
  type        = number
  default     = 90
}

variable "noncurrent_version_expiration_days" {
  description = "Days before expiring noncurrent versions"
  type        = number
  default     = 180
}

variable "enable_logging" {
  description = "Enable S3 bucket logging"
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "Target bucket for logging"
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefix for log objects"
  type        = string
  default     = "logs/"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
