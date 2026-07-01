data "aws_region" "current" {}



locals {
  frontend_repository_name = "${var.project_name}/${var.environment}/react-frontend"
  backend_repository_name  = "${var.project_name}/${var.environment}/fastapi-backend"
  bootstrap_role_name      = element(split("/", var.bootstrap_role_arn), length(split("/", var.bootstrap_role_arn)) - 1)
}

resource "aws_ecr_repository" "frontend" {
  name                 = local.frontend_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
  }

  tags = merge(var.tags, {
    Name        = local.frontend_repository_name
    Environment = var.environment
  })
}

resource "aws_ecr_repository" "backend" {
  name                 = local.backend_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
  }

  tags = merge(var.tags, {
    Name        = local.backend_repository_name
    Environment = var.environment
  })
}

resource "aws_ecr_lifecycle_policy" "frontend" {
  repository = aws_ecr_repository.frontend.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep latest 20 revision-tagged frontend images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["${var.environment}-"]
          countType     = "imageCountMoreThan"
          countNumber   = 20
        }
        action = { type = "expire" }
      }
    ]
  })
}

resource "aws_ecr_lifecycle_policy" "backend" {
  repository = aws_ecr_repository.backend.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep latest 20 revision-tagged backend images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["${var.environment}-"]
          countType     = "imageCountMoreThan"
          countNumber   = 20
        }
        action = { type = "expire" }
      }
    ]
  })
}

resource "aws_iam_role" "deploy" {
  name = "${var.project_name}-${var.environment}-github-actions-deploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.bootstrap_role_arn
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, {
    Environment = var.environment
  })
}

resource "aws_iam_role_policy" "deploy" {
  name = "${var.project_name}-${var.environment}-deploy-policy"
  role = aws_iam_role.deploy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::${var.terraform_state_bucket}/${var.project_name}/${var.environment}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = "arn:aws:s3:::${var.terraform_state_bucket}"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem",
          "dynamodb:DescribeTable"
        ]
        Resource = "arn:aws:dynamodb:${data.aws_region.current.name}:${var.tooling_account_id}:table/${var.terraform_lock_table}"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext",
          "kms:DescribeKey",
          "kms:ReEncryptFrom",
          "kms:ReEncryptTo"
        ]
        Resource = var.terraform_state_kms_key_arn
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:*",
          "ec2:*",
          "autoscaling:*",
          "elasticloadbalancing:*",
          "rds:*",
          "route53:*",
          "acm:*",
          "cloudwatch:*",
          "logs:*",
          "secretsmanager:*",
          "ssm:*",
          "kms:*",
          "iam:Get*",
          "iam:List*",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:CreateInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:PassRole",
          "iam:TagRole",
          "iam:TagPolicy",
          "iam:TagInstanceProfile"
        ]
        Resource = "*"
      }
    ]
  })
}

# Backend access for the existing GitHub Actions bootstrap role itself.
# This fixes failures where the bootstrap role can assume via OIDC but cannot
# decrypt the KMS-encrypted Terraform lock table/state backend.
data "aws_iam_policy_document" "bootstrap_terraform_backend_access" {
  statement {
    sid    = "AllowTerraformStateBucketAccess"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      "arn:aws:s3:::${var.terraform_state_bucket}",
      "arn:aws:s3:::${var.terraform_state_bucket}/*"
    ]
  }

  statement {
    sid    = "AllowTerraformLockTableAccess"
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem",
      "dynamodb:DescribeTable"
    ]

    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${var.tooling_account_id}:table/${var.terraform_lock_table}"
    ]
  }

  statement {
    sid    = "AllowTerraformBackendKMSAccess"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:DescribeKey",
      "kms:ReEncryptFrom",
      "kms:ReEncryptTo"
    ]

    resources = [
      var.terraform_state_kms_key_arn
    ]
  }
}

resource "aws_iam_policy" "bootstrap_terraform_backend_access" {
  name        = "${var.project_name}-${var.environment}-bootstrap-terraform-backend-access"
  description = "Allows the existing GitHub Actions bootstrap role to access Terraform S3 state, DynamoDB lock table, and KMS key."
  policy      = data.aws_iam_policy_document.bootstrap_terraform_backend_access.json

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-bootstrap-terraform-backend-access"
    Environment = var.environment
  })
}

resource "aws_iam_role_policy_attachment" "bootstrap_terraform_backend_access" {
  role       = local.bootstrap_role_name
  policy_arn = aws_iam_policy.bootstrap_terraform_backend_access.arn
}

data "aws_iam_policy_document" "terraform_backend_access" {
  statement {
    sid    = "AllowTerraformStateBucketAccess"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      "arn:aws:s3:::${var.terraform_state_bucket}",
      "arn:aws:s3:::${var.terraform_state_bucket}/*"
    ]
  }

  statement {
    sid    = "AllowTerraformLockTableAccess"
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem",
      "dynamodb:DescribeTable"
    ]

    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${var.tooling_account_id}:table/${var.terraform_lock_table}"
    ]
  }

  statement {
    sid    = "AllowTerraformBackendKMSAccess"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:DescribeKey",
      "kms:ReEncryptFrom",
      "kms:ReEncryptTo"
    ]

    resources = [
      var.terraform_state_kms_key_arn
    ]
  }
}

resource "aws_iam_policy" "terraform_backend_access" {
  name        = "${var.project_name}-${var.environment}-terraform-backend-access"
  description = "Allows GitHub Actions bootstrap role to access Terraform S3 state, DynamoDB lock table, and KMS key."

  policy = data.aws_iam_policy_document.terraform_backend_access.json

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-terraform-backend-access"
    Environment = var.environment
  })
}

resource "aws_iam_role_policy_attachment" "terraform_backend_access" {
  role       = local.bootstrap_role_name
  policy_arn = aws_iam_policy.terraform_backend_access.arn
}