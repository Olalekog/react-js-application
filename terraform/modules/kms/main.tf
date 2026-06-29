data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_kms_key" "this" {
  description             = "KMS key for ${var.name_prefix}"
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation

  tags = merge(var.tags, { Name = "${var.name_prefix}-kms" })
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.name_prefix}-kms"
  target_key_id = aws_kms_key.this.key_id
}
