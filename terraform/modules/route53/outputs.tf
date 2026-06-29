output "public_hosted_zone_id" {
  value = var.create_public_hosted_zone ? aws_route53_zone.public[0].zone_id : var.existing_public_hosted_zone_id
}

output "public_hosted_zone_name_servers" {
  value = var.create_public_hosted_zone ? aws_route53_zone.public[0].name_servers : []
}

output "frontend_public_fqdn" {
  value = try(aws_route53_record.frontend_public[0].fqdn, null)
}

output "private_hosted_zone_id" {
  value = try(aws_route53_zone.private[0].zone_id, null)
}

output "backend_private_fqdn" {
  value = try(aws_route53_record.backend_private[0].fqdn, null)
}
