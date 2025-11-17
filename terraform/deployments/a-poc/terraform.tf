terraform {
  required_version = ">= 1.13.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.00"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.0"
    }
  }

  backend "azurerm" {
    subscription_id      = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    resource_group_name  = "rg-core-iac-prd"
    storage_account_name = "stcoreiacprd001"
    container_name       = "tf-state-level2"
    key                  = "poc.tfstate"
  }
}
