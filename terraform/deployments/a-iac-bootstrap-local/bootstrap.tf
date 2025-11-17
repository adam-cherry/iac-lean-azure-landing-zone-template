#########################################################
# Bootstrap Basics
#########################################################

# --- Provider Registration ---
resource "azurerm_resource_provider_registration" "required" {
  for_each = toset(local.resource_providers)
  name     = each.value
}

# --- Naming: Resource Group ---
module "naming_rg" {
  source      = "../../modules/helpers/a-naming"
  type        = "extended"
  abbr        = "rg"
  rootid      = local.root_id
  environment = local.environment
  component   = "iac"
}

# --- Resource Group ---
resource "azurerm_resource_group" "backend" {
  name     = module.naming_rg.name
  location = local.location
  tags     = local.resource_tags_default

  depends_on = [azurerm_resource_provider_registration.required]
}

# --- Naming: Log Analytics Workspace ---
module "naming_law" {
  source      = "../../modules/helpers/a-naming"
  type        = "extended"
  abbr        = "log"
  rootid      = local.root_id
  environment = local.environment
  component   = "iac"
  index       = "001"
}

# --- Log Analytics Workspace ---
resource "azurerm_log_analytics_workspace" "iac_law" {
  name                = module.naming_law.name
  location            = local.location
  resource_group_name = azurerm_resource_group.backend.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.resource_tags_default

  depends_on = [azurerm_resource_group.backend]
}


########################################
# Bootstrap Storage (remote backend)
########################################

module "bootstrap_storage" {
  source = "../../modules/wrappers/az-storage-account"

  app       = local.root_id
  env       = local.environment
  st_index  = "001"
  component = "iac"

  resource_group_name        = azurerm_resource_group.backend.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.iac_law.id
  lock                       = local.backend_lock

  resource_tags_default         = local.resource_tags_default
  network_rules                 = null
  public_network_access_enabled = true
  role_assignments              = local.backend_storage_role_assignments
  containers                    = local.backend_containers

  depends_on = [
    azurerm_log_analytics_workspace.iac_law
  ]
}


########################################
# Bootstrap Key Vault
########################################

# tfsec:ignore:azure-keyvault-specify-network-acl
module "bootstrap_keyvault" {
  source = "../../modules/wrappers/az-keyvault"

  app       = local.root_id
  env       = local.environment
  component = "iac"
  kv_index  = "001"

  resource_group_name        = azurerm_resource_group.backend.name
  location                   = local.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.iac_law.id
  sku_name                   = local.backend_keyvault_sku

  public_network_access_enabled = true
  network_acls                  = local.backend_keyvault_network_acls
  role_assignments              = local.backend_keyvault_role_assignments
  resource_tags_default         = local.resource_tags_default

  depends_on = [
    azurerm_log_analytics_workspace.iac_law
  ]
}


########################################
# Service Principal for Terraform CI/CD
########################################

module "tf_pipeline_sp" {
  source = "../../modules/wrappers/az-service-principal"

  app          = local.root_id
  env          = local.environment
  purpose      = "pipeline"
  key_vault_id = module.bootstrap_keyvault.key_vault_id

  depends_on = [
    module.bootstrap_keyvault
  ]
}

resource "azurerm_role_assignment" "sp_reader_rg" {
  scope                = module.bootstrap_storage.storage_account_id
  role_definition_name = "Reader"
  principal_id         = module.tf_pipeline_sp.sp_object_id
}

resource "azurerm_role_assignment" "sp_storage_keys" {
  scope                = module.bootstrap_storage.storage_account_id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = module.tf_pipeline_sp.sp_object_id
}


module "naming" {
  source      = "../../modules/helpers/a-naming"
  type        = "identity"
  abbr        = "aadgrp"
  rootid      = local.root_id
  environment = local.environment
  purpose     = "ops"
}

# Needs AAD Global Admin Role to create the group
resource "azuread_group" "tf_ops" {
  display_name     = module.naming.name
  description      = "Azure AD group for Terraform Operations (service principals from CI/CD pipelines"
  security_enabled = true
}

# SP aus Bootstrap-Deployment in die Gruppe aufnehmen
resource "azuread_group_member" "sp_member" {
  group_object_id  = azuread_group.tf_ops.object_id
  member_object_id = module.tf_pipeline_sp.sp_object_id
}
