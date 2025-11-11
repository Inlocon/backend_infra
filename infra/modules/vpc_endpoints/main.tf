# allow HTTPS from within VPC
resource "aws_security_group" "vpcendpoints" {
  name        = "${var.env}-vpcendpoints-sg"
  description = "Allow 443 from VPC to interface endpoints"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  tags = { Name = "${var.env}-vpcendpoints-sg" }
}

data "aws_region" "current" {}

# s3 gateway endpoint (no sg needed)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids # should contain at least the id of the private route table
}

# interface endpoints for SSM (and friends)
locals {
  services = [
    "ssm",
    "ssmmessages",
    "ec2messages",
    "secretsmanager"
  ]
}

resource "aws_vpc_endpoint" "endpoints" {
  for_each           = toset(local.services)
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.private_subnet_ids
  security_group_ids = [aws_security_group.vpcendpoints.id]
  private_dns_enabled = true
}