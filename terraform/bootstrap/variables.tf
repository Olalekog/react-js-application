variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "tooling_account_id" {
  type = string
}

variable "bootstrap_role_arn" {
  type = string
}

variable "terraform_state_bucket" {
  type = string
}

variable "terraform_lock_table" {
  type = string
}

variable "terraform_state_kms_key_arn" {
  type = string
}

variable "tags" {
  description = "Common tags applied to bootstrap resources."
  type        = map(string)
  default     = {}
}
