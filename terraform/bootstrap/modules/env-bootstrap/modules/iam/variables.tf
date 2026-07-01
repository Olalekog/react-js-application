variable "project_name" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "bootstrap_role_name" {
  description = "Name of the existing GitHub Actions bootstrap role."
  type        = string
}

variable "terraform_state_bucket" {
  description = "Terraform state S3 bucket name."
  type        = string
}

variable "terraform_lock_table" {
  description = "Terraform DynamoDB lock table name."
  type        = string
}

variable "tooling_account_id" {
  description = "AWS account ID where Terraform backend resources exist."
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN used by the Terraform backend."
  type        = string
}

variable "aws_region" {
  description = "AWS region where the Terraform lock table exists."
  type        = string
}
