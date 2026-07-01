output "deploy_role_arn" {
  value = aws_iam_role.deploy.arn
}

output "frontend_repository_name" {
  value = aws_ecr_repository.frontend.name
}

output "backend_repository_name" {
  value = aws_ecr_repository.backend.name
}

output "frontend_repository_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "backend_repository_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "bootstrap_terraform_backend_policy_arn" {
  description = "IAM policy ARN attached to the bootstrap role for Terraform backend access."
  value       = aws_iam_policy.bootstrap_terraform_backend_access.arn
}
