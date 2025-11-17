terraform {
  required_version = ">= 1.13.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.00"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.00"
    }
  }

  backend "azurerm" {
    subscription_id      = "XXXXXXXXXXXXXXXXXXX" # replace with your IaC subscription ID
    resource_group_name  = "rg-core-iac-prd"
    storage_account_name = "stcoreiacprd001"
    container_name       = "tf-state-level1"
    key                  = "a-platform-gov.tfstate"
  }
}
