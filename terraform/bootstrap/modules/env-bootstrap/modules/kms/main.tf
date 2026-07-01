resource "aws_kms_grant" "bootstrap_backend_access" {
  name              = "${var.project_name}-${var.environment}-bootstrap-backend-access"
  key_id            = var.kms_key_arn
  grantee_principal = var.bootstrap_role_arn

  operations = [
    "Decrypt",
    "Encrypt",
    "GenerateDataKey",
    "GenerateDataKeyWithoutPlaintext",
    "DescribeKey",
    "ReEncryptFrom",
    "ReEncryptTo"
  ]

  retiring_principal = var.bootstrap_role_arn
}
