terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }

  required_version = ">=1.9.0"

  backend "s3" {
    bucket         = "tfstate-terraform-ansible-ssm-demo"
    key            = "terraform-ansible-ssm"
    region         = "us-east-2"
    dynamodb_table = "terraform-ansible-ssm-terraform-locks"
  }
}

provider "aws" {}
