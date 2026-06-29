output "public_alb_sg_id" { value = aws_security_group.public_alb.id }
output "frontend_ec2_sg_id" { value = aws_security_group.frontend_ec2.id }
output "internal_alb_sg_id" { value = aws_security_group.internal_alb.id }
output "backend_ec2_sg_id" { value = aws_security_group.backend_ec2.id }
output "rds_sg_id" { value = aws_security_group.rds.id }
