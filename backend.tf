terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.57"
    }
  }

  required_version = ">=1.9.0"

  backend "s3" {
    bucket         = "terraform-tfstate-k8s-downscaler"
    key            = "k8s-downscaler"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {}
