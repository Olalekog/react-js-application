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
      "arn:aws:dynamodb:${var.aws_region}:${var.tooling_account_id}:table/${var.terraform_lock_table}"
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
      var.kms_key_arn
    ]
  }
}

resource "aws_iam_role_policy" "terraform_backend_access" {
  name   = "${var.project_name}-${var.environment}-terraform-backend-access"
  role   = var.bootstrap_role_name
  policy = data.aws_iam_policy_document.terraform_backend_access.json
}
