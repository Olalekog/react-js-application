# Bootstrap KMS Backend Policy Update

This package updates the bootstrap root module and the `env-bootstrap` child module to attach Terraform backend access permissions to the existing GitHub Actions bootstrap IAM role.

Bootstrap role:

```text
arn:aws:iam::866934333672:role/react-js-application-github-actions-bootstrap-role
```

The Terraform-managed policy allows the bootstrap role to access:

- Terraform state S3 bucket
- Terraform DynamoDB lock table
- Terraform backend KMS key

Required GitHub variables:

```text
AWS_REGION=us-east-1
PROJECT_NAME=react-js-application
AWS_ACCOUNT_ID=866934333672
TOOLING_ACCOUNT_ID=866934333672
BOOTSTRAP_ROLE_ARN=arn:aws:iam::866934333672:role/react-js-application-github-actions-bootstrap-role
TF_STATE_BUCKET=react-js-application-terraform-state-866934333672
TF_LOCK_TABLE=react-js-application-terraform-locks
TF_STATE_KMS_KEY_ID=<kms-key-id-or-alias-used-for-backend-init>
TF_STATE_KMS_KEY_ARN=arn:aws:kms:us-east-1:866934333672:key/77381c82-55eb-4243-856a-639c56e87309
TERRAFORM_VERSION=1.9.0
```

Important: if the workflow currently fails during `terraform init` because the bootstrap role cannot decrypt the KMS-encrypted DynamoDB lock table/state backend, Terraform may not be able to apply this fix by itself yet. In that case, apply this policy once through the tooling stack or temporarily grant the bootstrap role KMS access manually, then let Terraform manage it going forward.
