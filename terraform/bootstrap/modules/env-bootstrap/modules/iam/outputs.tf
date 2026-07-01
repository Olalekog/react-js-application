output "policy_name" {
  description = "Inline policy name attached to the bootstrap role."
  value       = aws_iam_role_policy.terraform_backend_access.name
}
