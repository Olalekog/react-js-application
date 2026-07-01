output "grant_id" {
  description = "KMS grant ID for the bootstrap role."
  value       = aws_kms_grant.bootstrap_backend_access.grant_id
}

output "grant_token" {
  description = "KMS grant token."
  value       = aws_kms_grant.bootstrap_backend_access.grant_token
  sensitive   = true
}
