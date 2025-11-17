module "naming" {
  source      = "../../helpers/a-naming"
  type        = "compact_extended"
  abbr        = "st"
  rootid      = var.app
  environment = var.env
  component   = var.component
  index       = var.st_index
}

resource "azurerm_storage_account" "this" {
  name                            = module.naming.name
  resource_group_name             = var.resource_group_name
  location                        = local.location
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  account_kind                    = var.account_kind
  access_tier                     = var.access_tier
  min_tls_version                 = var.min_tls_version
  public_network_access_enabled   = var.public_network_access_enabled
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public

  blob_properties {
    last_access_time_enabled = var.last_access_time_enabled
  }
  dynamic "network_rules" {
    for_each = var.network_rules != null ? [var.network_rules] : []
    content {
      default_action             = try(network_rules.value.default_action, "Deny")
      bypass                     = try(network_rules.value.bypass, ["Logging", "Metrics", "AzureServices"])
      ip_rules                   = try(network_rules.value.ip_rules, [])
      virtual_network_subnet_ids = try(network_rules.value.virtual_network_subnet_ids, [])
    }
  }

  tags = var.resource_tags_default
}

# Create containers if specified
resource "azurerm_storage_container" "this" {
  for_each           = var.containers
  name               = each.key
  storage_account_id = azurerm_storage_account.this.id
  container_access_type = (
    each.value.public_access != null ?
    lower(each.value.public_access) :
    "private"
  )
}

module "diagnostics" {
  source                     = "../../helpers/a-diagnostics"
  resource_type              = "storage"
  resource_name              = azurerm_storage_account.this.name
  target_resource_id         = "${azurerm_storage_account.this.id}/blobServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id
}

module "diagnostics_file" {
  source                     = "../../helpers/a-diagnostics"
  resource_type              = "storage"
  resource_name              = "${azurerm_storage_account.this.name}-file"
  target_resource_id         = "${azurerm_storage_account.this.id}/fileServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  scope                            = azurerm_storage_account.this.id
  role_definition_name             = each.value.role_definition_id_or_name
  principal_id                     = each.value.principal_id
  skip_service_principal_aad_check = lookup(each.value, "skip_service_principal_aad_check", true)
  principal_type                   = lookup(each.value, "principal_type", "ServicePrincipal")

  depends_on = [azurerm_storage_account.this]
}

resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  name       = var.lock.name
  scope      = azurerm_storage_account.this.id
  lock_level = var.lock.kind
  notes      = "This lock was automatically created by Terraform for governance protection."

  depends_on = [azurerm_storage_account.this]
}