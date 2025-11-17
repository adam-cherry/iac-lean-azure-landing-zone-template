output "vnet_id" {
  description = "VNet resource ID"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "VNet name"
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of subnet IDs by key"
  value       = { for k, s in azurerm_subnet.subnet : k => s.id }
}

output "nsg_ids" {
  description = "Map of NSG IDs by key"
  value       = { for k, n in azurerm_network_security_group.nsg : k => n.id }
}

output "route_table_ids" {
  description = "Map of route table IDs by key"
  value       = { for k, r in azurerm_route_table.rt : k => r.id }
}
