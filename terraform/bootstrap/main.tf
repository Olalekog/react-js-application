locals {
  common_tags = merge(var.tags, {
    Project   = var.project_name
    ManagedBy = "Terraform"
  })
}

module "dev_environment_bootstrap" {
  source = "./modules/env-bootstrap"

  project_name               = var.project_name
  environment                = "dev"
  account_id                 = var.aws_account_id
  tooling_account_id         = var.tooling_account_id
  bootstrap_role_arn         = var.bootstrap_role_arn
  terraform_state_bucket     = var.terraform_state_bucket
  terraform_lock_table       = var.terraform_lock_table
  terraform_state_kms_key_arn = var.terraform_state_kms_key_arn

  tags = merge(local.common_tags, {
    Environment = "dev"
  })
}

module "uat_environment_bootstrap" {
  source = "./modules/env-bootstrap"

  project_name               = var.project_name
  environment                = "uat"
  account_id                 = var.aws_account_id
  tooling_account_id         = var.tooling_account_id
  bootstrap_role_arn         = var.bootstrap_role_arn
  terraform_state_bucket     = var.terraform_state_bucket
  terraform_lock_table       = var.terraform_lock_table
  terraform_state_kms_key_arn = var.terraform_state_kms_key_arn

  tags = merge(local.common_tags, {
    Environment = "uat"
  })
}

module "production_environment_bootstrap" {
  source = "./modules/env-bootstrap"

  project_name               = var.project_name
  environment                = "production"
  account_id                 = var.aws_account_id
  tooling_account_id         = var.tooling_account_id
  bootstrap_role_arn         = var.bootstrap_role_arn
  terraform_state_bucket     = var.terraform_state_bucket
  terraform_lock_table       = var.terraform_lock_table
  terraform_state_kms_key_arn = var.terraform_state_kms_key_arn

  tags = merge(local.common_tags, {
    Environment = "production"
  })
}