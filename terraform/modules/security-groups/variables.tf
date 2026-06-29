variable "name_prefix" { type = string }
variable "vpc_id" { type = string }
variable "public_alb_ingress_cidrs" { type = list(string) }
variable "frontend_container_port" { type = number }
variable "backend_container_port" { type = number }
variable "db_port" { type = number }
variable "tags" {
  type    = map(string)
  default = {}
}
