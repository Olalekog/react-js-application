variable "project_name" {
  description = "Project name used for naming resources."
  type        = string
}

variable "environment" {
  description = "Environment name such as dev, uat, or production."
  type        = string
}

variable "account_id" {
  description = "AWS account ID where the environment resources are created."
  type        = string
}

variable "tooling_account_id" {
  description = "AWS account ID where Terraform backend resources are managed. For single-account deployments, this can be the same as account_id."
  type        = string
}

variable "bootstrap_role_arn" {
  description = "Bootstrap IAM role ARN assumed by GitHub Actions using OIDC."
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
  description = "KMS key ARN used to encrypt Terraform state and lock table."
  type        = string
}

variable "tags" {
  description = "Common tags applied to resources."
  type        = map(string)
  default     = {}
}
