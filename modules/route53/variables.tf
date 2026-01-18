variable "domain_name" {
  description = "Domain name for the hosted zone"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "Zone ID of the ALB"
  type        = string
}

variable "domain_validation_options" {
  description = "Domain validation options from ACM module"
  type = set(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_value = string
    resource_record_type  = string
  }))
  default = []
}

variable "common_tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
