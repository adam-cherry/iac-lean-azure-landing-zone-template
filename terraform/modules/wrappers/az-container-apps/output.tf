# --- Basic Info ---
output "container_app_names" {
  description = "Names of all Container Apps"
  value       = { for k, v in azurerm_container_app.apps : k => v.name }
}

output "container_app_ids" {
  description = "Resource IDs of all Container Apps"
  value       = { for k, v in azurerm_container_app.apps : k => v.id }
}

output "container_app_fqdns" {
  description = "FQDNs of all Container Apps (if ingress enabled)"
  value       = { for k, v in azurerm_container_app.apps : k => try(v.ingress[0].fqdn, null) }
}
