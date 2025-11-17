# -------------------------------------------------------------
#  Naming (Compute schema)
# -------------------------------------------------------------
module "naming_aca_env" {
  source      = "../../helpers/a-naming"
  type        = "standard"
  abbr        = "cae"
  rootid      = var.app
  environment = var.env
  index       = var.env_index
}

# -------------------------------------------------------------
#  Container Apps Environment
# -------------------------------------------------------------
resource "azurerm_container_app_environment" "this" {
  name                = module.naming_aca_env.name
  location            = local.location
  resource_group_name = var.resource_group_name
  tags                = var.resource_tags_default

  infrastructure_subnet_id       = var.infrastructure_subnet_id
  internal_load_balancer_enabled = var.internal_load_balancer_enabled
  zone_redundancy_enabled        = var.zone_redundancy_enabled

  log_analytics_workspace_id = var.log_analytics_workspace_id

  # optional workload profile (Dedicated plans)
  dynamic "workload_profile" {
    for_each = var.workload_profile
    content {
      name                  = workload_profile.value.name
      workload_profile_type = workload_profile.value.workload_profile_type
      minimum_count         = workload_profile.value.minimum_count
      maximum_count         = workload_profile.value.maximum_count
    }
  }
}

# -------------------------------------------------------------
#  Diagnostics
# -------------------------------------------------------------
module "diagnostics" {
  source                     = "../../helpers/a-diagnostics"
  resource_type              = "container_environment"
  resource_name              = azurerm_container_app_environment.this.name
  target_resource_id         = azurerm_container_app_environment.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}
