locals {
  environments = toset(["dev", "uat", "production"])

  common_tags = merge(var.tags, {
    Project   = var.project_name
    ManagedBy = "terraform"
  })
}

module "environment_bootstrap" {
  for_each = local.environments

  source = "./modules/env-bootstrap"

  project_name                = var.project_name
  environment                 = each.key
  account_id                  = var.aws_account_id
  tooling_account_id          = var.tooling_account_id
  bootstrap_role_arn          = var.bootstrap_role_arn
  terraform_state_bucket      = var.terraform_state_bucket
  terraform_lock_table        = var.terraform_lock_table
  terraform_state_kms_key_arn = var.terraform_state_kms_key_arn

  tags = merge(local.common_tags, {
    Environment = each.key
  })
}

resource "aws_ssm_parameter" "deploy_role_arn" {
  for_each = module.environment_bootstrap

  name   = "/${var.project_name}/${each.key}/github-actions/deploy-role-arn"
  type   = "SecureString"
  value  = each.value.deploy_role_arn
  key_id = var.terraform_state_kms_key_arn

  tags = merge(local.common_tags, {
    Environment = each.key
  })
}


