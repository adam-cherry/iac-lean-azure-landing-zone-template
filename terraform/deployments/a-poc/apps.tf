resource "azurerm_resource_group" "backend" {
  location = local.location
  name     = "${local.root_id}-rg"
  tags     = local.resource_tags_default
}

module "aca_env_poc" {
  source = "../../modules/wrappers/az-container-env"

  app       = local.root_id
  env       = local.environment
  env_index = "001"

  resource_group_name        = azurerm_resource_group.backend.name
  infrastructure_subnet_id   = module.vnet.subnet_ids["aca_infra"]
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  internal_load_balancer_enabled = true
  zone_redundancy_enabled        = false

  resource_tags_default = local.resource_tags_default

  depends_on = [module.vnet]
}

# --- Container Apps Deployment ---
module "aca_apps" {
  source = "../../modules/wrappers/az-container-apps"

  app       = local.root_id
  env       = local.environment
  app_index = "001"

  resource_group_name        = azurerm_resource_group.backend.name
  environment_id             = module.aca_env_poc.aca_environment_id
  user_assigned_identity_id  = azurerm_user_assigned_identity.uami.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  resource_tags_default      = local.resource_tags_default

  #Skeleton image deployment, replace with real apps definition via pipeline
  apps = local.apps

  depends_on = [module.aca_env_poc]
}

