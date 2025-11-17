#!/bin/bash

cat > main.tf <<EOF
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

EOF

cat > terraform.tf <<EOF
terraform {
  required_version = ">= 1.13.0"

    required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.00"
    }
  }

  backend "azurerm" {
    resource_group_name  = "base-tfbootstrap"
    storage_account_name = "abasebackendsa"
    container_name       = "tf-state-level2"
    key                  = ""
  }
}
EOF

cat > variables.tf <<EOF
# tflint-ignore: terraform_unused_declarations
variable "root_id" {
  type        = string
  description = "If specified, will set a custom Name (ID) value and append this to the ID for all core Enterprise-scale Ressources."
}

variable "location" {
  type        = string
  default     = "germanywestcentral"
  description = "Azure region (primary)"
}

variable "tenant_id" {
  type        = string
  description = "The ID for our Microsoft Entra ID tenant."
}
variable "subscription_id" {
  type        = string
  description = "If specified, identifies the subscription for resource deployment"
}

  # tflint-ignore: terraform_unused_declarations
variable "resource_tags_default" {
  type        = map(string)
  description = "A map of Tags that will be applied to Azure resources, e.g. 'project' or 'cost-center'."
}

EOF

cat > outputs.tf <<EOF
output "location" {
  value = var.location
}
EOF

cat > terraform.tfvars <<EOF
root_id                    = "a"
tenant_id                  = "XXXXXXXXXXXXXXXXXXXXXX" # Base Platform Tenant
subscription_id            = ""

resource_tags_default = {
  company = "acompany"
  created-by           = "xxx xxxx"
  managed-by-terraform = "true"
  project = "aproject"
}
EOF
