output "deploy_role_arns" {
  value = { for env, module_value in module.environment_bootstrap : env => module_value.deploy_role_arn }
}

output "frontend_ecr_repository_urls" {
  value = { for env, module_value in module.environment_bootstrap : env => module_value.frontend_repository_url }
}

output "backend_ecr_repository_urls" {
  value = { for env, module_value in module.environment_bootstrap : env => module_value.backend_repository_url }
}
