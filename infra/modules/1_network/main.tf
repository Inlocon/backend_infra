data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  public_subnets = {
    for key, cfg in var.subnet_config : key => cfg if try(cfg.public, false)
  }
  private_subnets = {
    for key, cfg in var.subnet_config : key => cfg if !try(cfg.public, false)
  }
  allowed_azs = data.aws_availability_zones.available.names
  used_azs    = distinct([for k, v in var.subnet_config : v.az])
  invalid_azs = [for az in local.used_azs : az if !contains(local.allowed_azs, az)]
  tags = { resourceGroup = "networking" }
}

check "at_least_one_public_and_private_subnet" {
  assert {
    condition     = length(local.public_subnets) > 0
    error_message = "You must define at least one public subnet."
  }
  assert {
    condition     = length(local.private_subnets) > 0
    error_message = "You must define at least one private subnet."
  }
}

check "azs_valid" {
  assert {
    condition = length(local.invalid_azs) == 0
    error_message = <<EOT
      Invalid AZ(s): ${join(", ", local.invalid_azs)}
      Used: ${join(", ", local.used_azs)}
      Allowed: ${join(", ", local.allowed_azs)}
      EOT
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_config.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.tags
}

resource "aws_subnet" "this" {
  for_each                = var.subnet_config
  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.value.az
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = try(each.value.public, false)

  tags = merge({Name = "${var.env}-${each.key}"}, local.tags)
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = local.tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = local.tags
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_assoc" {
  for_each = local.public_subnets

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags = local.tags
}

resource "aws_route_table_association" "private_assoc" {
  for_each = local.private_subnets
  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.private.id
}
