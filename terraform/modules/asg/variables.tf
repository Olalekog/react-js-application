variable "name_prefix" { type = string }
variable "aws_region" { type = string }
variable "target_account_id" { type = string }
variable "vpc_subnet_ids" { type = list(string) }
variable "security_group_id" { type = string }
variable "target_group_arn" { type = string }
variable "instance_type" { type = string }
variable "min_size" { type = number }
variable "desired_capacity" { type = number }
variable "max_size" { type = number }
variable "docker_image" { type = string }
variable "container_port" { type = number }
variable "environment" { type = string }
variable "app_environment_variables" {
  type    = map(string)
  default = {}
}

variable "secret_arns" {
  type    = list(string)
  default = []
}

variable "kms_key_arn" {
  type = string
}

variable "root_volume_size" {
  type    = number
  default = 20
}

variable "root_volume_type" {
  type    = string
  default = "gp3"
}

variable "root_device_name" {
  type    = string
  default = "/dev/xvda"
}

variable "ami_name_filter" {
  type    = string
  default = "al2023-ami-*-x86_64"
}

variable "tags" {
  type    = map(string)
  default = {}
}
