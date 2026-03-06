terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.22.0"
    }
  }
  backend "s3" {
    region = "eu-central-1"
  }
}

#