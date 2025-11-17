output "diagnostic_setting_name" {
  description = "The name of the created diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.this.name
}

output "categories_enabled" {
  description = "List of enabled log categories."
  value       = local.categories
}
