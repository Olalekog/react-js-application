output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_name" {
  value = var.vpc_name
}

output "selected_availability_zones" {
  value = local.selected_availability_zones
}

output "public_subnet_ids" {
  value = values(aws_subnet.public)[*].id
}

output "private_frontend_subnet_ids" {
  value = values(aws_subnet.private_frontend)[*].id
}

output "private_backend_subnet_ids" {
  value = values(aws_subnet.private_backend)[*].id
}

output "private_db_subnet_ids" {
  value = values(aws_subnet.private_db)[*].id
}
