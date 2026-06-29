output "frontend_public_fqdn" {
  value = try(aws_route53_record.frontend_public[0].fqdn, null)
}

output "backend_private_fqdn" {
  value = try(aws_route53_record.backend_private[0].fqdn, null)
}
