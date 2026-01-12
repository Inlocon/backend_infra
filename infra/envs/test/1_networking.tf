########################################################################################################################
# Network wiring, basically single-AZ - the 2nd private/public networks in different AZ's are only there because
# ALB requires a 2nd public subnet (in different AZ) and RDS subnetgroup requires a 2nd private subnet (in different AZ)
########################################################################################################################

locals {
  vpc_cidrs = {
    test = "10.10.0.0/16"
    prod = "10.11.0.0/16"
  }
  vpc_cidr = local.vpc_cidrs[var.env]
}

module "network" {
  source = "../../modules/network"

  vpc_config = {
    name       = "${var.env}-vpc"
    cidr_block = local.vpc_cidr
  }

  subnet_config = {
    public-1 = {
      cidr_block = cidrsubnet(local.vpc_cidr, 8, 0) # "10.10.0.0/24"
      public     = true
      az         = "eu-central-1a"
    }

    # alb needs a 2nd public subnet, even if all task would live in one subnet
    public-2 = {
      cidr_block = cidrsubnet(local.vpc_cidr, 8, 1) # "10.10.1.0/24"
      public     = true
      az         = "eu-central-1b"
    }

    # Private subnet (RDS subnet group requires at least 2 different private subnets in different AZ's)
    private-1 = {
      cidr_block = cidrsubnet(local.vpc_cidr, 8, 128) # "10.10.128.0/24"
      public     = false
      az         = "eu-central-1a"
    }
    # add later, if rds-instance should be deployed multi-az
    private-2 = {
      cidr_block = cidrsubnet(local.vpc_cidr, 8, 129) # "10.10.129.0/24"
      public     = false
      az         = "eu-central-1b"
    }
  }
}