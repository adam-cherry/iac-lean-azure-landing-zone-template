output "app_client_id" {
  description = "AzureAD App Registration Client ID"
  value       = azuread_application.app.client_id
}

output "app_object_id" {
  description = "AzureAD Application Object ID"
  value       = azuread_application.app.object_id
}

output "sp_object_id" {
  description = "Service Principal Object ID"
  value       = azuread_service_principal.sp.object_id
}

output "keyvault_secret_id" {
  description = "ID of the created secret in Key Vault (if any)"
  value       = try(azurerm_key_vault_secret.secret.id, null)
}