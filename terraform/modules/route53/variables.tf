variable "name_prefix" {
  description = "Name prefix for Route 53 resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID used for private hosted zone association"
  type        = string
}

variable "create_public_hosted_zone" {
  description = "Create a new public hosted zone for the application domain"
  type        = bool
  default     = false
}

variable "existing_public_hosted_zone_id" {
  description = "Existing public hosted zone ID. Leave empty if creating a new public zone or not using public DNS."
  type        = string
  default     = ""
}

variable "public_hosted_zone_name" {
  description = "Public hosted zone name, for example example.com"
  type        = string
  default     = ""
}

variable "create_public_record" {
  description = "Create a public Route 53 alias record for the public frontend ALB"
  type        = bool
  default     = false
}

variable "frontend_public_record_name" {
  description = "Frontend public DNS record name, for example dev.example.com or app.example.com"
  type        = string
  default     = ""
}

variable "public_alb_dns_name" {
  description = "Public ALB DNS name"
  type        = string
  default     = ""
}

variable "public_alb_zone_id" {
  description = "Public ALB hosted zone ID"
  type        = string
  default     = ""
}

variable "create_private_hosted_zone" {
  description = "Create a private hosted zone for internal application DNS"
  type        = bool
  default     = true
}

variable "private_hosted_zone_name" {
  description = "Private hosted zone name, for example dev.three-tier-app.internal"
  type        = string
}

variable "create_private_record" {
  description = "Create a private Route 53 alias record for the internal backend ALB"
  type        = bool
  default     = true
}

variable "backend_private_record_name" {
  description = "Backend private DNS record name. Use api to create api.<private_hosted_zone_name>."
  type        = string
  default     = "api"
}

variable "internal_alb_dns_name" {
  description = "Internal ALB DNS name"
  type        = string
  default     = ""
}

variable "internal_alb_zone_id" {
  description = "Internal ALB hosted zone ID"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
