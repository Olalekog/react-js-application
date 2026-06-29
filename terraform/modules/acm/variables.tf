variable "name_prefix" {
  description = "Name prefix for ACM resources"
  type        = string
}

variable "domain_name" {
  description = "Primary DNS name for the certificate, for example app.dev.mydevopsprojects.shop"
  type        = string
}

variable "subject_alternative_names" {
  description = "Optional SAN names for the certificate"
  type        = list(string)
  default     = []
}

variable "hosted_zone_id" {
  description = "Route 53 public hosted zone ID used for ACM DNS validation"
  type        = string
}

variable "validation_record_ttl" {
  description = "TTL for ACM DNS validation records"
  type        = number
  default     = 60
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
