#Service Principal for Terraform pipelines from bootstrap
data "terraform_remote_state" "bootstrap" {
  backend = "azurerm"
  config = {
    subscription_id      = "aceb27a9-3908-473a-8038-bdd5e713f4a6"
    resource_group_name  = "rg-core-iac-prd"
    storage_account_name = "stcoreiacprd001"
    container_name       = "tf-state-level0"
    key                  = "backend.tfstate"
  }
}

locals {
  tf_ops_group_object_id = data.terraform_remote_state.bootstrap.outputs.tf_ops_group.object_id
}
