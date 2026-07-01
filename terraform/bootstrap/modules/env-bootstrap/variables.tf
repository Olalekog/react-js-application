variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "account_id" {
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
  type    = map(string)
  default = {}
}
