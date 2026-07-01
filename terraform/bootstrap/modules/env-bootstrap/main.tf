data "aws_region" "current" {}

data "aws_iam_policy_document" "github_actions_deploy_assume_role" {
  statement {
    sid     = "AllowBootstrapRoleAssumeDeployRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.bootstrap_role_arn]
    }
  }
}

locals {
  bootstrap_role_name = element(split("/", var.bootstrap_role_arn), length(split("/", var.bootstrap_role_arn)) - 1)
}

resource "aws_iam_role" "deploy" {
  name               = "${var.project_name}-${var.environment}-github-actions-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.github_actions_deploy_assume_role.json

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-github-actions-deploy-role"
    Environment = var.environment
  })
}

resource "aws_ecr_repository" "frontend" {
  name                 = "${var.project_name}/${var.environment}/react-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-react-frontend"
    Environment = var.environment
  })
}

resource "aws_ecr_repository" "backend" {
  name                 = "${var.project_name}/${var.environment}/fastapi-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-fastapi-backend"
    Environment = var.environment
  })
}

module "iam_backend_access" {
  source = "./modules/iam"

  project_name           = var.project_name
  environment            = var.environment
  bootstrap_role_name    = local.bootstrap_role_name
  terraform_state_bucket = var.terraform_state_bucket
  terraform_lock_table   = var.terraform_lock_table
  tooling_account_id     = var.tooling_account_id
  kms_key_arn            = var.terraform_state_kms_key_arn
  aws_region             = data.aws_region.current.region
}

module "kms_backend_access" {
  source = "./modules/kms"

  project_name         = var.project_name
  environment          = var.environment
  bootstrap_role_arn   = var.bootstrap_role_arn
  kms_key_arn          = var.terraform_state_kms_key_arn
  grant_creation_token = "${var.project_name}-${var.environment}-bootstrap-backend-access"
}
