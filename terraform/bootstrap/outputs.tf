output "deploy_role_arns" {
  description = "GitHub Actions deploy role ARNs by environment."

  value = {
    dev        = module.dev_environment_bootstrap.deploy_role_arn
    uat        = module.uat_environment_bootstrap.deploy_role_arn
    production = module.production_environment_bootstrap.deploy_role_arn
  }
}

output "frontend_ecr_repository_urls" {
  description = "Frontend ECR repository URLs by environment."

  value = {
    dev        = module.dev_environment_bootstrap.frontend_repository_url
    uat        = module.uat_environment_bootstrap.frontend_repository_url
    production = module.production_environment_bootstrap.frontend_repository_url
  }
}

output "backend_ecr_repository_urls" {
  description = "Backend ECR repository URLs by environment."

  value = {
    dev        = module.dev_environment_bootstrap.backend_repository_url
    uat        = module.uat_environment_bootstrap.backend_repository_url
    production = module.production_environment_bootstrap.backend_repository_url
  }
}

output "bootstrap_backend_access_policy_names" {
  description = "Inline IAM policy names attached to the bootstrap role for Terraform backend access."

  value = {
    dev        = module.dev_environment_bootstrap.bootstrap_backend_access_policy_name
    uat        = module.uat_environment_bootstrap.bootstrap_backend_access_policy_name
    production = module.production_environment_bootstrap.bootstrap_backend_access_policy_name
  }
}

output "bootstrap_kms_grant_ids" {
  description = "KMS grant IDs created for the bootstrap role by environment."

  value = {
    dev        = module.dev_environment_bootstrap.bootstrap_kms_grant_id
    uat        = module.uat_environment_bootstrap.bootstrap_kms_grant_id
    production = module.production_environment_bootstrap.bootstrap_kms_grant_id
  }
}
