output "location" {
  value = local.location
}

## GOV 
output "mgmt_group_ids" {
  value = {
    root   = azurerm_management_group.root.id
    level1 = { for k, v in azurerm_management_group.level1 : k => v.id }
    level2 = { for k, v in azurerm_management_group.level2 : k => v.id }
  }
}
