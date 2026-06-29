resource "aws_security_group" "public_alb" {
  name   = "${var.name_prefix}-public-alb-sg"
  vpc_id = var.vpc_id
  ingress { from_port = 80 to_port = 80 protocol = "tcp" cidr_blocks = var.public_alb_ingress_cidrs }
  ingress { from_port = 443 to_port = 443 protocol = "tcp" cidr_blocks = var.public_alb_ingress_cidrs }
  egress { from_port = var.frontend_container_port to_port = var.frontend_container_port protocol = "tcp" security_groups = [aws_security_group.frontend_ec2.id] }
  tags = merge(var.tags, { Name = "${var.name_prefix}-public-alb-sg" })
}

resource "aws_security_group" "frontend_ec2" {
  name   = "${var.name_prefix}-frontend-ec2-sg"
  vpc_id = var.vpc_id
  ingress { from_port = var.frontend_container_port to_port = var.frontend_container_port protocol = "tcp" security_groups = [aws_security_group.public_alb.id] }
  egress { from_port = var.backend_container_port to_port = var.backend_container_port protocol = "tcp" security_groups = [aws_security_group.internal_alb.id] }
  egress { from_port = 443 to_port = 443 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  tags = merge(var.tags, { Name = "${var.name_prefix}-frontend-ec2-sg" })
}

resource "aws_security_group" "internal_alb" {
  name   = "${var.name_prefix}-internal-alb-sg"
  vpc_id = var.vpc_id
  ingress { from_port = var.backend_container_port to_port = var.backend_container_port protocol = "tcp" security_groups = [aws_security_group.frontend_ec2.id] }
  egress { from_port = var.backend_container_port to_port = var.backend_container_port protocol = "tcp" security_groups = [aws_security_group.backend_ec2.id] }
  tags = merge(var.tags, { Name = "${var.name_prefix}-internal-alb-sg" })
}

resource "aws_security_group" "backend_ec2" {
  name   = "${var.name_prefix}-backend-ec2-sg"
  vpc_id = var.vpc_id
  ingress { from_port = var.backend_container_port to_port = var.backend_container_port protocol = "tcp" security_groups = [aws_security_group.internal_alb.id] }
  egress { from_port = var.db_port to_port = var.db_port protocol = "tcp" security_groups = [aws_security_group.rds.id] }
  egress { from_port = 443 to_port = 443 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  tags = merge(var.tags, { Name = "${var.name_prefix}-backend-ec2-sg" })
}

resource "aws_security_group" "rds" {
  name   = "${var.name_prefix}-rds-sg"
  vpc_id = var.vpc_id
  ingress { from_port = var.db_port to_port = var.db_port protocol = "tcp" security_groups = [aws_security_group.backend_ec2.id] }
  tags = merge(var.tags, { Name = "${var.name_prefix}-rds-sg" })
}
