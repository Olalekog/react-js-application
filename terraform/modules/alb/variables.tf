variable "name_prefix" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_backend_subnet_ids" { type = list(string) }
variable "public_alb_sg_id" { type = string }
variable "internal_alb_sg_id" { type = string }
variable "frontend_port" { type = number }
variable "backend_port" { type = number }
variable "frontend_health_check_path" { type = string }
variable "backend_health_check_path" { type = string }

variable "enable_https" {
  description = "Enable HTTPS listener on public ALB"
  type        = bool
  default     = true
}

variable "certificate_arn" {
  description = "ACM certificate ARN for the public ALB HTTPS listener"
  type        = string
  default     = ""
}

variable "ssl_policy" {
  description = "TLS security policy for the public HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "redirect_http_to_https" {
  description = "Redirect HTTP traffic to HTTPS on the public ALB"
  type        = bool
  default     = true
}

variable "tags" { type = map(string) default = {} }
