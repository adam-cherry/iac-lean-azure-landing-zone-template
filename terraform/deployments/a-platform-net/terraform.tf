terraform {
  required_version = ">= 1.13.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.00"
    }
  }

  backend "azurerm" {
    resource_group_name  = "core-tfbootstrap"
    storage_account_name = "corebackendsa"
    container_name       = "tf-state-level1"
    key                  = "a-platform-net.tfstate"
  }
}
