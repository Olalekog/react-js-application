variable "public_zone_id" {
  description = "Public hosted zone ID"
  type        = string
  default     = ""
}

variable "private_zone_id" {
  description = "Private hosted zone ID"
  type        = string
  default     = ""
}

variable "create_public_record" {
  description = "Create public frontend records"
  type        = bool
  default     = false
}

variable "frontend_public_record_name" {
  description = "Frontend public record name"
  type        = string
  default     = ""
}

variable "public_alb_dns_name" {
  description = "Public ALB DNS name"
  type        = string
  default     = ""
}

variable "public_alb_zone_id" {
  description = "Public ALB canonical hosted zone ID"
  type        = string
  default     = ""
}

variable "create_private_record" {
  description = "Create private backend record"
  type        = bool
  default     = true
}

variable "backend_private_record_name" {
  description = "Backend private record name"
  type        = string
  default     = "api"
}

variable "internal_alb_dns_name" {
  description = "Internal ALB DNS name"
  type        = string
  default     = ""
}

variable "internal_alb_zone_id" {
  description = "Internal ALB canonical hosted zone ID"
  type        = string
  default     = ""
}
