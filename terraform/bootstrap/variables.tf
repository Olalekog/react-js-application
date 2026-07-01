variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "project_name" {
  description = "Project name."
  type        = string
}

variable "aws_account_id" {
  description = "Single AWS account ID used for dev, uat, and production."
  type        = string
}

variable "tooling_account_id" {
  description = "Tooling AWS account ID. For this single-account design, this is the same as aws_account_id."
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
  description = "Terraform DynamoDB state lock table name."
  type        = string
}

variable "terraform_state_kms_key_arn" {
  description = "KMS key ARN used to encrypt Terraform state and the DynamoDB lock table."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
