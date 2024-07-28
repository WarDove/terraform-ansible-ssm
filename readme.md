![Logo](https://s3.eu-central-1.amazonaws.com/huseynov.tarlan/devops-bordered.png)

# Downscaler: EKS Golang Client
### From Code to Cloud with Terraform - E2E Continious Deployment to AWS Lambda

## Overview
Welcome to the EKS-Downscaler Lambda project! This guide walks you through setting up a seamless deployment of a compiled Lambda function that interacts with your EKS cluster using Terraform.

## Guide/Reference
https://dev.to

## Installation
To get started, ensure you have the following prerequisites installed:

- [Terraform](https://www.terraform.io/downloads)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#cliv2-linux-install)

## Getting Started

Set up your AWS profile:

```sh
export AWS_PROFILE=<your-profile>
```

Initialize Terraform, validate the configuration, plan the deployment, and apply it:
```sh
terraform init
terraform validate
terraform plan
terraform apply
```
## Motive
- Infrastructure as Code (IaC): Automate the provisioning of all necessary cloud components with Terraform, ensuring consistent and repeatable deployments.
- Cost Optimization: Use Lambda functions to manage EKS resources dynamically, helping to optimize costs.
- Scalability: Easily scale the solution to manage multiple EKS clusters and workloads.