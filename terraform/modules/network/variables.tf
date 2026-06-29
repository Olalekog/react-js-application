variable "name_prefix" {
  description = "Name prefix for network resources"
  type        = string
}

variable "vpc_name" {
  description = "Explicit VPC Name tag, for example vpc-dev, vpc-uat, or vpc-production"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "az_count" {
  description = "Number of available Availability Zones to use dynamically"
  type        = number
  default     = 3
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks. Length must match az_count."
  type        = list(string)
}

variable "private_frontend_subnet_cidrs" {
  description = "Private frontend subnet CIDR blocks. Length must match az_count."
  type        = list(string)
}

variable "private_backend_subnet_cidrs" {
  description = "Private backend subnet CIDR blocks. Length must match az_count."
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "Private database subnet CIDR blocks. Length must match az_count."
  type        = list(string)
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
