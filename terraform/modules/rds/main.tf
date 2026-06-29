resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.db_subnet_ids
  tags = merge(var.tags, { Name = "${var.name_prefix}-db-subnet-group" })
}
resource "aws_db_instance" "this" {
  identifier        = "${var.name_prefix}-mysql"
  engine            = "mysql"
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type      = var.db_storage_type
  db_name           = var.db_name
  username          = var.db_username
  port              = var.db_port
  manage_master_user_password   = true
  master_user_secret_kms_key_id = var.kms_key_arn
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_security_group_id]
  publicly_accessible = false
  multi_az            = var.db_multi_az
  storage_encrypted   = true
  kms_key_id          = var.kms_key_arn
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot
  performance_insights_enabled    = var.performance_insights_enabled
  performance_insights_kms_key_id = var.kms_key_arn
  tags = merge(var.tags, { Name = "${var.name_prefix}-mysql" })
}
