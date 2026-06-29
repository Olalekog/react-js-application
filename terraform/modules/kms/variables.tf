variable "name_prefix" { type = string }
variable "enable_key_rotation" { type = bool default = true }
variable "deletion_window_in_days" { type = number default = 30 }
variable "tags" { type = map(string) default = {} }
