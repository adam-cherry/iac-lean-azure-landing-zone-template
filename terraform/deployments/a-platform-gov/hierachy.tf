# Root MG

resource "azurerm_management_group" "root" {
  display_name = local.mgmt_groups.root
  name         = local.mgmt_groups.root
}

# Level 1 MGs
resource "azurerm_management_group" "level1" {
  for_each = local.mgmt_groups.level1

  display_name               = each.value
  name                       = each.value
  parent_management_group_id = azurerm_management_group.root.id

}

# Level 2 MGs
resource "azurerm_management_group" "level2" {
  for_each = merge([
    for parent, children in local.mgmt_groups.level2 : {
      for name, display in children :
      "${parent}-${name}" => {
        display_name = display
        name         = name
        parent       = parent
      }
    }
  ]...)

  display_name               = each.value.display_name
  name                       = "a-${each.value.name}"
  parent_management_group_id = azurerm_management_group.level1[each.value.parent].id
}

# Subscriptions
resource "azurerm_management_group_subscription_association" "subs" {
  for_each = local.subscriptions

  subscription_id = each.value.id

  management_group_id = try(
    azurerm_management_group.level1[each.value.mg_parent].id,
    azurerm_management_group.level2[each.value.mg_parent].id
  )

  depends_on = [azurerm_management_group.level1, azurerm_management_group.level2]
}
