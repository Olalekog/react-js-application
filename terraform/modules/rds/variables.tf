variable "name_prefix" { type = string }
variable "db_subnet_ids" { type = list(string) }
variable "db_security_group_id" { type = string }
variable "db_engine_version" { type = string }
variable "db_instance_class" { type = string }
variable "db_allocated_storage" { type = number }
variable "db_storage_type" { type = string default = "gp3" }
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_port" { type = number }
variable "db_multi_az" { type = bool }
variable "backup_retention_period" { type = number }
variable "deletion_protection" { type = bool }
variable "skip_final_snapshot" { type = bool }
variable "performance_insights_enabled" { type = bool }
variable "kms_key_arn" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
