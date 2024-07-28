locals {
  default_tags = {
    Environment = var.env
    OrgUnit     = "Devops"
    Managed-by  = "Terraform"
  }
}