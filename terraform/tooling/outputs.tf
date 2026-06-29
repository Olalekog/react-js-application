output "bootstrap_role_arn" {
  value = aws_iam_role.react-app-tooling-bootstrap.arn
}

output "terraform_state_bucket" {
  value = aws_s3_bucket.state-file-bucket.bucket
}

output "terraform_lock_table" {
  value = aws_dynamodb_table.state-file-locks.name
}

output "terraform_state_kms_key_id" {
  value = aws_kms_alias.state-file-key-alias.name
}

output "terraform_state_kms_key_arn" {
  value = aws_kms_key.state-file-key.arn
}
