output "aca_environment_id" {
  description = "Resource ID of the Container Apps Environment"
  value       = azurerm_container_app_environment.this.id
}

output "aca_environment_name" {
  description = "Name of the Container Apps Environment"
  value       = azurerm_container_app_environment.this.name
}

output "aca_environment_static_ip" {
  description = "Static IP of the Container Apps Environment"
  value       = try(azurerm_container_app_environment.this.static_ip_address, null)
}