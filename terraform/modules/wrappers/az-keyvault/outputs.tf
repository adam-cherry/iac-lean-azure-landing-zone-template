output "key_vault_id" {
  description = "Key Vault Resource ID"
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "Key Vault name"
  value       = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  description = "Key Vault URI (DNS name)"
  value       = azurerm_key_vault.this.vault_uri
}