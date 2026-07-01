variable "project_name" {
  description = "Project name used for naming resources."
  type        = string
}

variable "environment" {
  description = "Environment name such as dev, uat, or production."
  type        = string
}

variable "account_id" {
  description = "AWS account ID where resources are deployed."
  type        = string
}

variable "tooling_account_id" {
  description = "Tooling AWS account ID. For single-account deployments, this is the same as account_id."
  type        = string
}

variable "bootstrap_role_arn" {
  description = "Existing GitHub Actions bootstrap IAM role ARN."
  type        = string
}

variable "terraform_state_bucket" {
  description = "Terraform remote state S3 bucket name."
  type        = string
}

variable "terraform_lock_table" {
  description = "Terraform DynamoDB lock table name."
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