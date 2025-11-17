## Ressource Layer
## ADD Layer only via local Global Admin Deployment except SP should get ADD roles  
## SP needs to get permission infront to assign roles in MG scope via Global Admin 

# Contributor auf Root-MG (a-base)
resource "azurerm_role_assignment" "mg_root_contrib" {
  scope                = azurerm_management_group.root.id
  role_definition_name = "Owner"
  principal_id         = local.tf_ops_group_object_id
}

# Policy Contributor auf Root-MG (a-base)
resource "azurerm_role_assignment" "mg_root_policy_contrib" {
  scope                = azurerm_management_group.root.id
  role_definition_name = "Resource Policy Contributor"
  principal_id         = local.tf_ops_group_object_id
}

