variable "aws_region" {
  description = "AWS region where bootstrap resources are created."
  type        = string
}

variable "project_name" {
  description = "Project name used for naming resources."
  type        = string
}

variable "aws_account_id" {
  description = "Single AWS account ID used for dev, uat, and production."
  type        = string
}

variable "tooling_account_id" {
  description = "AWS account ID where tooling resources are managed. For single-account deployments, this is usually the same as aws_account_id."
  type        = string
}

variable "bootstrap_role_arn" {
  description = "GitHub Actions bootstrap role ARN assumed through OIDC."
  type        = string
}

variable "terraform_state_bucket" {
  description = "S3 bucket used for Terraform remote state."
  type        = string
}

variable "terraform_lock_table" {
  description = "DynamoDB table used for Terraform state locking."
  type        = string
}

variable "terraform_state_kms_key_arn" {
  description = "KMS key ARN used to encrypt Terraform state and SecureString parameters."
  type        = string
}

variable "tags" {
  description = "Common tags applied to bootstrap resources."
  type        = map(string)
  default     = {}
}
