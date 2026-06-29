resource "aws_route53_record" "frontend_public" {
  count = var.create_public_record && var.public_zone_id != "" ? 1 : 0

  zone_id = var.public_zone_id
  name    = var.frontend_public_record_name
  type    = "A"

  alias {
    name                   = var.public_alb_dns_name
    zone_id                = var.public_alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "frontend_public_ipv6" {
  count = var.create_public_record && var.public_zone_id != "" ? 1 : 0

  zone_id = var.public_zone_id
  name    = var.frontend_public_record_name
  type    = "AAAA"

  alias {
    name                   = var.public_alb_dns_name
    zone_id                = var.public_alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "backend_private" {
  count = var.create_private_record && var.private_zone_id != "" ? 1 : 0

  zone_id = var.private_zone_id
  name    = var.backend_private_record_name
  type    = "A"

  alias {
    name                   = var.internal_alb_dns_name
    zone_id                = var.internal_alb_zone_id
    evaluate_target_health = true
  }
}
