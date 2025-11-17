########################################
# Restrict deployments to germanywestcentral
########################################

# Built-in Policy: "Allowed locations" (ID below)
resource "azurerm_management_group_policy_assignment" "enforce_allowed_locations" {
  name                = "a-location-enforce"
  display_name        = "Restrict deployments to approved Azure region"
  description         = "Prevents resource creation outside approved Azure region."
  management_group_id = azurerm_management_group.root.id

  # Use the official built-in policy definition ID
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"

  metadata = jsonencode({
    assignedBy = "Terraform (acompany Governance)"
  })

  # Enforce mode (default = true)
  enforce = true

  # Restrict allowed locations
  parameters = jsonencode({
    listOfAllowedLocations = {
      value = [local.location] # "germanywestcentral"
    }
  })
}
