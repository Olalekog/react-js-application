resource "aws_route53_zone" "public" {
  count = var.create_public_hosted_zone ? 1 : 0

  name = var.public_hosted_zone_name

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-public-zone"
  })
}

locals {
  public_zone_id = var.create_public_hosted_zone ? aws_route53_zone.public[0].zone_id : var.existing_public_hosted_zone_id
}

resource "aws_route53_record" "frontend_public" {
  count = var.create_public_record && local.public_zone_id != "" ? 1 : 0

  zone_id = local.public_zone_id
  name    = var.frontend_public_record_name
  type    = "A"

  alias {
    name                   = var.public_alb_dns_name
    zone_id                = var.public_alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "frontend_public_ipv6" {
  count = var.create_public_record && local.public_zone_id != "" ? 1 : 0

  zone_id = local.public_zone_id
  name    = var.frontend_public_record_name
  type    = "AAAA"

  alias {
    name                   = var.public_alb_dns_name
    zone_id                = var.public_alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_zone" "private" {
  count = var.create_private_hosted_zone ? 1 : 0

  name = var.private_hosted_zone_name

  vpc {
    vpc_id = var.vpc_id
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-private-zone"
  })
}

resource "aws_route53_record" "backend_private" {
  count = var.create_private_hosted_zone && var.create_private_record ? 1 : 0

  zone_id = aws_route53_zone.private[0].zone_id
  name    = var.backend_private_record_name
  type    = "A"

  alias {
    name                   = var.internal_alb_dns_name
    zone_id                = var.internal_alb_zone_id
    evaluate_target_health = true
  }
}
