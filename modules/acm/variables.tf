variable "domain_name" {
  description = "Domain name for the certificate"
  type        = string
}

variable "validation_record_fqdns" {
  description = "List of FQDNs for validation records (from Route53 module)"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
