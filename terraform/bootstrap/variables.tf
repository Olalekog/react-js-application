variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "project_name" {
  description = "Project name."
  type        = string
}

variable "aws_account_id" {
  description = "Single AWS account ID."
  type        = string
}

variable "tooling_account_id" {
  description = "Tooling AWS account ID."
  type        = string
}

variable "bootstrap_role_arn" {
  description = "GitHub Actions bootstrap IAM role ARN."
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

variable "terraform_state_kms_key_arn" {
  description = "Terraform state KMS key ARN."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}