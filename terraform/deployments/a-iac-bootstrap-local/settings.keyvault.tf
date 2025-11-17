locals {
  # Standard SKU is sufficient for backend
  backend_keyvault_sku = "standard"

  # Rules for IP exemptions
  # Enable Network Rules for only trusted IPs and subnets
  # tflint-ignore: terraform_unused_declarations
  backend_keyvault_network_acls = {
    bypass   = "AzureServices"
    ip_rules = local.backend_ip_rules
  }

  # Key Vault Secrets Officer for L0 SPN on vault level
  backend_keyvault_role_assignments = {
    role_assignment_local_1 = {
      role_definition_id_or_name       = "Key Vault Secrets Officer"
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = true
      principal_type                   = "User"
    }
    role_assignment_local_2 = {
      role_definition_id_or_name       = "Key Vault Secrets User"
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = true
      principal_type                   = "User"
    }
  }
}
