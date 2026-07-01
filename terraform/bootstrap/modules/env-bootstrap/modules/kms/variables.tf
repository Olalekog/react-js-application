variable "project_name" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "bootstrap_role_arn" {
  description = "Bootstrap role ARN that needs KMS access to the Terraform backend key."
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN used by the Terraform backend."
  type        = string
}

variable "grant_creation_token" {
  description = "Unique creation token for idempotent KMS grant creation."
  type        = string
}
