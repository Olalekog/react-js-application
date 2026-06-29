output "public_alb_arn" {
  value = aws_lb.public.arn
}

output "public_alb_dns_name" {
  value = aws_lb.public.dns_name
}

output "public_alb_zone_id" {
  value = aws_lb.public.zone_id
}

output "public_https_listener_arn" {
  value = try(aws_lb_listener.public_https[0].arn, null)
}

output "internal_alb_dns_name" {
  value = aws_lb.internal.dns_name
}

output "internal_alb_zone_id" {
  value = aws_lb.internal.zone_id
}

output "frontend_target_group_arn" {
  value = aws_lb_target_group.frontend.arn
}

output "backend_target_group_arn" {
  value = aws_lb_target_group.backend.arn
}
