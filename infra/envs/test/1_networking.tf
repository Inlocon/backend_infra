########################################################################################################################
# Network wiring, basically single-AZ - the 2nd private/public networks in different AZ's are only there because
# ALB requires a 2nd public subnet (in different AZ) and RDS subnetgroup requires a 2nd private subnet (in different AZ)
########################################################################################################################
# terraform import 'module.network.aws_vpc.this' vpc-0b8fd2ae364d56b05
# terraform import 'module.network.aws_subnet.this["public-1"]'  subnet-0a3e9617937b3d3be
# terraform import 'module.network.aws_subnet.this["public-2"]'  subnet-0d7db52ad299c0c03
# terraform import 'module.network.aws_subnet.this["private-1"]' subnet-0324c2ca59cc19c80
# terraform import 'module.network.aws_subnet.this["private-2"]' subnet-0bab14e7377a67d59

module "network" {
  source = "../../modules/network"

  vpc_config = {
    name       = "test-vpc"
    cidr_block = "10.10.0.0/16"
  }

  subnet_config = {
    public-1 = {
      cidr_block = "10.10.0.0/24"
      public     = true
      az         = "eu-central-1a"
    }

    # alb needs a 2nd public subnet, even if all task would live in one subnet
    public-2 = {
      cidr_block = "10.10.1.0/24"
      public     = true
      az         = "eu-central-1b"
    }

    # Private subnet (RDS subnet group requires at least 2 different private subnets in different AZ's)
    private-1 = {
      cidr_block = "10.10.128.0/24"
      public     = false
      az         = "eu-central-1a"
    }
    private-2 = {
      cidr_block = "10.10.129.0/24"
      public     = false
      az         = "eu-central-1b"
    }
  }
  tags = {
    project     = "inlocon-backend"
    environment = "test"
    managed-by  = "terraform"
  }
}