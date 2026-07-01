# output "deploy_role_arns" {
#   value = {
#     dev        = module.dev_environment_bootstrap.deploy_role_arn
#     uat        = module.uat_environment_bootstrap.deploy_role_arn
#     production = module.production_environment_bootstrap.deploy_role_arn
#   }
# }

output "frontend_ecr_repository_urls" {
  value = {
    dev        = module.dev_environment_bootstrap.frontend_repository_url
    uat        = module.uat_environment_bootstrap.frontend_repository_url
    production = module.production_environment_bootstrap.frontend_repository_url
  }
}

output "backend_ecr_repository_urls" {
  value = {
    dev        = module.dev_environment_bootstrap.backend_repository_url
    uat        = module.uat_environment_bootstrap.backend_repository_url
    production = module.production_environment_bootstrap.backend_repository_url
  }
}
