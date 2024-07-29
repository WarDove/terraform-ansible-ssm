#!/bin/sh
set -euo pipefail

PROJECT_NAME=terraform-ansible-ssm
AWS_REGION=${AWS_REGION:-us-east-2}
AWS_PROFILE=${AWS_PROFILE:-default}
AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
export AWS_PAGER=""



echo -e "Bootstrapping terraform backend...\n"
echo PROJECT_NAME: "${PROJECT_NAME}"
echo AWS_REGION: "${AWS_REGION}"
echo AWS_PROFILE: "${AWS_PROFILE}"
echo AWS_ACCOUNT_ID: "${AWS_ACCOUNT_ID}"
echo BUCKET NAME: "tfstate-${PROJECT_NAME}-${RANDOM_STRING}"
echo DYNAMODB TABLE NAME: "${PROJECT_NAME}-terraform-locks"
echo -e "\n"

aws s3api create-bucket \
	--region "${AWS_REGION}" \
	--create-bucket-configuration LocationConstraint="${AWS_REGION}" \
	--bucket "tfstate-${PROJECT_NAME}-${RANDOM_STRING}" 

aws dynamodb create-table \
	--region "${AWS_REGION}" \
	--table-name ${PROJECT_NAME}-terraform-locks \
	--attribute-definitions AttributeName=LockID,AttributeType=S \
	--key-schema AttributeName=LockID,KeyType=HASH \
	--provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

cat <<EOF > ./backend.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }

  required_version = ">=1.9.0"

  backend "s3" {
    bucket         = "tfstate-${PROJECT_NAME}-${RANDOM_STRING}"
    key            = "${PROJECT_NAME}"
    region         = "${AWS_REGION}"
    dynamodb_table = "${PROJECT_NAME}-terraform-locks"
  }
}

provider "aws" {}
EOF

echo -e "\nBackend configuration created successfully!\n"
cat ./backend.tf
