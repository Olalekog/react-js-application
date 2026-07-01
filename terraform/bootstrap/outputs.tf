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

output "bootstrap_terraform_backend_policy_arns" {
  description = "Terraform backend access policy ARNs attached to the bootstrap role by environment."

  value = {
    dev        = module.dev_environment_bootstrap.bootstrap_terraform_backend_policy_arn
    uat        = module.uat_environment_bootstrap.bootstrap_terraform_backend_policy_arn
    production = module.production_environment_bootstrap.bootstrap_terraform_backend_policy_arn
  }
}