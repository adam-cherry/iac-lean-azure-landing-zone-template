
module "naming_kv" {
  source      = "../../helpers/a-naming"
  type        = "extended"
  abbr        = "kv"
  rootid      = var.app
  environment = var.env
  component   = var.component
  index       = var.kv_index
}

resource "azurerm_key_vault" "this" {
  name                          = module.naming_kv.name
  resource_group_name           = var.resource_group_name
  location                      = local.location
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = var.sku_name
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  public_network_access_enabled = var.public_network_access_enabled
  rbac_authorization_enabled    = true

  dynamic "network_acls" {
    for_each = [coalesce(var.network_acls, {
      default_action             = "Deny"
      bypass                     = "AzureServices"
      ip_rules                   = []
      virtual_network_subnet_ids = []
    })]
    content {
      bypass                     = lookup(network_acls.value, "bypass", "AzureServices")
      default_action             = lookup(network_acls.value, "default_action", "Deny")
      ip_rules                   = lookup(network_acls.value, "ip_rules", [])
      virtual_network_subnet_ids = lookup(network_acls.value, "virtual_network_subnet_ids", [])
    }
  }

  tags = var.resource_tags_default
}

# --- Role Assignments ---
resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  scope                            = azurerm_key_vault.this.id
  role_definition_name             = each.value.role_definition_id_or_name
  principal_id                     = each.value.principal_id
  skip_service_principal_aad_check = lookup(each.value, "skip_service_principal_aad_check", true)
  principal_type                   = lookup(each.value, "principal_type", "ServicePrincipal")
}

# --- Diagnostics ---
module "diagnostics" {
  source                     = "../../helpers/a-diagnostics"
  resource_type              = "key_vault"
  resource_name              = azurerm_key_vault.this.name
  target_resource_id         = azurerm_key_vault.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}

