output "tenant_id" {
  description = "The Azure Tenant ID."
  value       = local.tenant_id
}

output "subscription_id" {
  description = "The ID for the core/Iac Azure subscription."
  value       = local.subscription_id_iac
}

output "root_id" {
  description = "The project's root id."
  value       = local.root_id
}

output "location" {
  description = "The project's primary Azure location."
  value       = local.location
}

output "resource_default_tags" {
  description = "A map of Tags that will be applied to Azure resources."
  value       = local.resource_tags_default
}


##bootstrap Outputs

output "backend_resource_group_name" {
  description = "Name of the bootstrap resource group"
  value       = azurerm_resource_group.backend.name
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.iac_law.name
}

output "bootstrap_storage_account_name" {
  description = "Name of the bootstrap storage account"
  value       = module.bootstrap_storage.storage_account_name
}

output "bootstrap_storage_account_id" {
  description = "Resource ID of the bootstrap storage account"
  value       = module.bootstrap_storage.storage_account_id
}

output "bootstrap_keyvault_name" {
  description = "Name of the bootstrap Key Vault"
  value       = module.bootstrap_keyvault.key_vault_name
}

output "bootstrap_keyvault_id" {
  description = "Resource ID of the bootstrap Key Vault"
  value       = module.bootstrap_keyvault.key_vault_id
}

output "bootstrap_keyvault_uri" {
  description = "Vault URI of the bootstrap Key Vault"
  value       = module.bootstrap_keyvault.key_vault_uri
}

output "pipeline_sp_client_id" {
  description = "Terraform pipeline Service Principal Client ID"
  value       = module.tf_pipeline_sp.app_client_id
}

output "pipeline_sp_object_id" {
  description = "Terraform pipeline Service Principal Object ID"
  value       = module.tf_pipeline_sp.sp_object_id
}

output "pipeline_sp_secret_id" {
  description = "ID of the stored sp secret in Key Vault"
  value       = module.tf_pipeline_sp.keyvault_secret_id
}

output "tf_ops_group" {
  description = "Azure AD group object for Terraform Operations"
  value = {
    display_name = azuread_group.tf_ops.display_name
    object_id    = azuread_group.tf_ops.object_id
    id           = azuread_group.tf_ops.id
  }
}