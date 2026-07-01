output "deploy_role_arn" {
  description = "GitHub Actions deploy role ARN for this environment."
  value       = aws_iam_role.deploy.arn
}

output "frontend_repository_url" {
  description = "Frontend ECR repository URL."
  value       = aws_ecr_repository.frontend.repository_url
}

output "backend_repository_url" {
  description = "Backend ECR repository URL."
  value       = aws_ecr_repository.backend.repository_url
}

output "bootstrap_backend_access_policy_name" {
  description = "Inline IAM policy name attached to the bootstrap role for backend access."
  value       = module.iam_backend_access.policy_name
}

output "bootstrap_kms_grant_id" {
  description = "KMS grant ID created for the bootstrap role."
  value       = module.kms_backend_access.grant_id
}
