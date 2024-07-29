![Logo](https://s3.eu-central-1.amazonaws.com/huseynov.tarlan/devops-bordered.png)

# Terraform-Ansible-SSM
### From Code to Cloud with Terraform, Ansible, and AWS Systems Manager

## Overview
Welcome to the Terraform-Ansible-SSM project! This guide walks you through setting up a seamless deployment of infrastructure using Terraform, Ansible, and AWS Systems Manager for secure and efficient configuration management.

## Guide/Reference - [dev.to article](https://dev.to/wardove/terraform-ansible-and-aws-systems-manager-pipeline-a-powerful-trio-for-seamless-aws-infrastructure-automation-5gb0)

## Installation
To get started, ensure you have the following prerequisites installed:

- [Terraform](https://www.terraform.io/downloads)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#cliv2-linux-install)
- [Docker](https://docs.docker.com/get-docker/)

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
- **Infrastructure as Code (IaC)**: Automate the provisioning of all necessary cloud components with Terraform, ensuring consistent and repeatable deployments.
- **Secure Configuration Management**: Use Ansible with AWS Systems Manager to manage EC2 instances without SSH, enhancing security.
- **Scalability and Efficiency**: Easily scale the solution to manage multiple AWS resources and workloads efficiently.
