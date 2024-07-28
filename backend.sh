#!/bin/bash
set -euo pipefail

PROJECT_NAME=$(basename "$(dirname \"${PWD}\")")
AWS_REGION=${AWS_REGION:-us-east-2}
AWS_PROFILE=${AWS_PROFILE:-default}
AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text --profile ${AWS_PROFILE})"
export AWS_PAGER=""

echo -e "Bootstraping terraform backend...\n"
echo PROJECT_NAME: "${PROJECT_NAME}"
echo AWS_REGION: "${AWS_REGION}"
echo AWS_PROFILE: "${AWS_PROFILE}"
echo AWS_ACCOUNT_ID: "${AWS_ACCOUNT_ID}"
echo BUCKET NAME: "terraform-tfstate-${PROJECT_NAME}"
echo DYNAMODB TABLE NAME: terraform-locks
echo -e "\n"

aws s3api create-bucket \
	--region "${AWS_REGION}" \
	--create-bucket-configuration LocationConstraint="${AWS_REGION}" \
	--bucket "terraform-tfstate-${PROJECT_NAME}" \
	--profile "${AWS_PROFILE}"

aws dynamodb create-table \
	--region "${AWS_REGION}" \
	--table-name terraform-locks \
	--attribute-definitions AttributeName=LockID,AttributeType=S \
	--key-schema AttributeName=LockID,KeyType=HASH \
	--provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
	--profile "${AWS_PROFILE}"

cat <<EOF > ./backend.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.57"
    }
  }

  required_version = ">=1.9.0"

  backend "s3" {
    bucket         = "terraform-tfstate-${PROJECT_NAME}"
    key            = "${PROJECT_NAME}"
    region         = "${AWS_REGION}"
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {}
EOF

echo -e "\nBackend configuration created successfully!\n"
cat ./backend.tf