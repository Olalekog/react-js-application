data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required", "opted-in"]
  }
}

locals {
  selected_availability_zones = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  public_subnets = {
    for index, cidr in var.public_subnet_cidrs : index => {
      cidr = cidr
      az   = local.selected_availability_zones[index]
    }
  }

  private_frontend_subnets = {
    for index, cidr in var.private_frontend_subnet_cidrs : index => {
      cidr = cidr
      az   = local.selected_availability_zones[index]
    }
  }

  private_backend_subnets = {
    for index, cidr in var.private_backend_subnet_cidrs : index => {
      cidr = cidr
      az   = local.selected_availability_zones[index]
    }
  }

  private_db_subnets = {
    for index, cidr in var.private_db_subnet_cidrs : index => {
      cidr = cidr
      az   = local.selected_availability_zones[index]
    }
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = var.vpc_name
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-igw"
  })
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-public-${tonumber(each.key) + 1}"
    Tier = "public"
    AZ   = each.value.az
  })
}

resource "aws_subnet" "private_frontend" {
  for_each = local.private_frontend_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-private-frontend-${tonumber(each.key) + 1}"
    Tier = "private-frontend"
    AZ   = each.value.az
  })
}

resource "aws_subnet" "private_backend" {
  for_each = local.private_backend_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-private-backend-${tonumber(each.key) + 1}"
    Tier = "private-backend"
    AZ   = each.value.az
  })
}

resource "aws_subnet" "private_db" {
  for_each = local.private_db_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-private-db-${tonumber(each.key) + 1}"
    Tier = "private-db"
    AZ   = each.value.az
  })
}

resource "aws_eip" "nat" {
  for_each = aws_subnet.public

  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-nat-eip-${tonumber(each.key) + 1}"
  })
}

resource "aws_nat_gateway" "this" {
  for_each = aws_subnet.public

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-nat-${tonumber(each.key) + 1}"
  })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  for_each = aws_nat_gateway.this

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = each.value.id
  }

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-private-rt-${tonumber(each.key) + 1}"
  })
}

resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-private-db-rt"
  })
}

resource "aws_route_table_association" "private_frontend" {
  for_each = aws_subnet.private_frontend

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route_table_association" "private_backend" {
  for_each = aws_subnet.private_backend

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route_table_association" "private_db" {
  for_each = aws_subnet.private_db

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_db.id
}
