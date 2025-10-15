# Maps with metadata
locals {
  output_public_subnets = {
    for key in keys(local.public_subnets) : key => {
      subnet_id         = aws_subnet.this[key].id
      availability_zone = aws_subnet.this[key].availability_zone
      cidr_block        = aws_subnet.this[key].cidr_block
    }
  }
  output_private_subnets = {
    for key in keys(local.private_subnets) : key => {
      subnet_id         = aws_subnet.this[key].id
      availability_zone = aws_subnet.this[key].availability_zone
      cidr_block        = aws_subnet.this[key].cidr_block
    }
  }
}

output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.this.id
}

output "public_subnets" {
  description = "Map: subnet_key => { subnet_id, availability_zone, cidr_block } for public subnets"
  value       = local.output_public_subnets
}

output "private_subnets" {
  description = "Map: subnet_key => { subnet_id, availability_zone, cidr_block } for private subnets"
  value       = local.output_private_subnets
}

# Convenience lists (often handy for consumers)
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for k in keys(local.public_subnets) : aws_subnet.this[k].id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for k in keys(local.private_subnets) : aws_subnet.this[k].id]
}
