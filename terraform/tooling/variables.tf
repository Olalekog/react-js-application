variable "aws_region" {
  type = string
}

variable "tooling_account_id" {
  type = string
}

variable "project_name" {
  type = string
}

variable "github_org" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

