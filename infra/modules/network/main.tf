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
  tags = { resourceGroup = "networking" }
}

# VPC
  resource "aws_vpc" "this" {
    cidr_block           = var.vpc_config.cidr_block
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = local.tags
  }

# Subnets
resource "aws_subnet" "this" {
  for_each                = var.subnet_config
  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.value.az
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = try(each.value.public, false)

  tags = merge({
    Name   = each.key
    Access = try(each.value.public, false) ? "Public" : "Private"
  }, local.tags)

  lifecycle {
    precondition {
      condition     = contains(data.aws_availability_zones.available.names, each.value.az)
      error_message = "Invalid AZ ${each.value.az}. Allowed: ${join(", ", data.aws_availability_zones.available.names)}"
    }
  }
}

# Internet Gateway only if at least one public subnet exists
resource "aws_internet_gateway" "this" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = local.tags
}

# Route table for public subnets (0.0.0.0/0 -> IGW)
resource "aws_route_table" "public" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = local.tags
}

resource "aws_route" "public_default" {
  count                  = length(local.public_subnets) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table_association" "public_assoc" {
  for_each = local.public_subnets

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public[0].id
}

# Private route table (no NAT; internal only)
resource "aws_route_table" "private" {
  count  = length(local.private_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = local.tags
}

resource "aws_route_table_association" "private_assoc" {
  for_each = local.private_subnets

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.private[0].id
}
