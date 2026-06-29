locals {
  name_prefix = "${var.project_name}-tooling"
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = "tooling"
    ManagedBy   = "terraform"
  })
}

resource "aws_kms_key" "state-file-key" {
  description             = "Terraform state KMS key"
  enable_key_rotation     = true
  deletion_window_in_days = 30
  tags = merge(local.common_tags, {
    Name = "tooling-${local.name_prefix}-state-kms"
  })
}

resource "aws_kms_alias" "state-file-key-alias" {
  name          = "alias/${local.name_prefix}-state-file-kms-key"
  target_key_id = aws_kms_key.state-file-key.key_id
}

resource "aws_s3_bucket" "state-file-bucket" {
  bucket = "${var.project_name}-tooling-terraform-state-${var.tooling_account_id}"
  tags = merge(local.common_tags, {
    Name = "tooling-${var.project_name}-terraform-state"
  })
}

resource "aws_s3_bucket_versioning" "state-file-bucket-versioning" {
  bucket = aws_s3_bucket.state-file-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state-file-bucket-encryption" {
  bucket = aws_s3_bucket.state-file-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.state-file-key.arn
      sse_algorithm     = "aws:kms"
    }

    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "state-file-bucket-access-block" {
  bucket                  = aws_s3_bucket.state-file-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "state-file-locks" {
  name         = "${var.project_name}-terraform-state-file-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.state-file-key.arn
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-terraform-locks"
  })
}

resource "aws_iam_openid_connect_provider" "github-rjs" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "tooling-bootstrap" {
  name = "${var.project_name}-github-actions-tooling-bootstrap-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github-rjs.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:*"
        }
      }
    }]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy" "tooling-bootstrap" {
  name = "${var.project_name}-bootstrap-policy"
  role = aws_iam_role.tooling-bootstrap.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ssm:GetParameter", "ssm:GetParameters", "ssm:PutParameter"]
        Resource = "arn:aws:ssm:${var.aws_region}:${var.tooling_account_id}:parameter/${var.project_name}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["kms:Decrypt", "kms:Encrypt", "kms:GenerateDataKey", "kms:DescribeKey"]
        Resource = aws_kms_key.state-file-key.arn
      },
      {
        Effect   = "Allow"
        Action   = ["sts:AssumeRole"]
        Resource = "arn:aws:iam::*:role/${var.project_name}-*-github-actions-deploy-role"
      },
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:ListBucket"]
        Resource = [aws_s3_bucket.state-file-bucket.arn, "${aws_s3_bucket.state-file-bucket.arn}/*"]
      },
      {
        Effect   = "Allow"
        Action   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem", "dynamodb:UpdateItem", "dynamodb:DescribeTable"]
        Resource = aws_dynamodb_table.state-file-locks.arn
      }
    ]
  })
}
