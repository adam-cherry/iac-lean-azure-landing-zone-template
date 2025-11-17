# Log Analytics Workspace - Integration
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${local.name_prefix}-law"
  location            = local.location
  resource_group_name = azurerm_resource_group.backend.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

# -------------------------
# Storage Account via a Module
# -------------------------

module "storage_account" {
  source = "../../modules/wrappers/az-storage-account"

  # Naming inputs (Naming Convention Module)
  app       = local.root_id
  env       = local.environment
  component = "internal"
  st_index  = "001"


  # Core resource config
  resource_group_name        = azurerm_resource_group.backend.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  # # Storage defaults
  # account_kind                 = "StorageV2"
  # account_tier                 = "Standard"
  # account_replication_type     = "LRS"
  # access_tier                  = "Hot"
  # public_network_access_enabled = false
  # enable_https_traffic_only     = true
  # default_action                = "Deny"
  # bypass                        = ["Metrics", "Logging"]

  # Optional private containers
  containers = {
    "appdata" = {}
    "states"  = {}
  }

  # Governance tags
  resource_tags_default = local.tags
}

module "naming" {
  source      = "../../modules/helpers/a-naming"
  type        = "standard"
  abbr        = "id"
  rootid      = local.root_id
  environment = local.environment
  index       = "001"
}


resource "azurerm_user_assigned_identity" "uami" {
  name                = module.naming.name
  location            = local.location
  resource_group_name = azurerm_resource_group.backend.name
  tags                = local.tags

}


data "azurerm_client_config" "current" {} # Pipeline

locals {
  keyvault_role_assignments = {
    kv_role_tf = {
      role_definition_id_or_name = "Key Vault Secrets Officer"
      principal_id               = data.azurerm_client_config.current.object_id
      principal_type             = "ServicePrincipal" # Pipeline
    }
  }

  keyvault_network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = ["84.135.254.126"]
  }
}


module "keyvault" {
  source = "../../modules/wrappers/az-keyvault"

  app       = local.root_id
  env       = local.environment
  component = "internal"
  kv_index  = "001"

  resource_group_name           = azurerm_resource_group.backend.name
  log_analytics_workspace_id    = azurerm_log_analytics_workspace.law.id
  network_acls                  = local.keyvault_network_acls
  public_network_access_enabled = true #Blocking ARM deployment without this set to true
  role_assignments              = local.keyvault_role_assignments


  resource_tags_default = local.resource_tags_default
}

