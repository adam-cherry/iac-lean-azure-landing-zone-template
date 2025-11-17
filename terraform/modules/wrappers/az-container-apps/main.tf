module "naming_ca" {
  for_each = var.apps

  source      = "../../helpers/a-naming"
  type        = "extended"
  abbr        = "ca"
  rootid      = var.app
  environment = var.env
  component   = each.key # frontend, api, etc.
  index       = each.value.index != null ? each.value.index : var.app_index
}


# --- Container Apps ---
resource "azurerm_container_app" "apps" {
  for_each = var.apps

  name                         = module.naming_ca[each.key].name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.environment_id
  revision_mode                = coalesce(try(each.value.revision_mode, null), "Single")
  tags                         = var.resource_tags_default

  # --- Template ---
  template {
    min_replicas = coalesce(try(each.value.template.min_replicas, null), 0)
    max_replicas = coalesce(try(each.value.template.max_replicas, null), 1)

    container {
      name   = each.key
      image  = coalesce(try(each.value.template.image, null), "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest")
      cpu    = coalesce(try(each.value.template.cpu, null), 0.25)
      memory = coalesce(try(each.value.template.memory, null), "0.5Gi")
    }
  }

  # --- Ingress ---
  ingress {
    external_enabled = coalesce(try(each.value.ingress.external_enabled, null), false)
    target_port      = coalesce(try(each.value.ingress.target_port, null), 80)
    transport        = coalesce(try(each.value.ingress.transport, null), "auto")

    dynamic "traffic_weight" {
      for_each = coalesce(try(each.value.ingress.traffic_weight, []), [])
      content {
        latest_revision = coalesce(try(traffic_weight.value.latest_revision, null), true)
        percentage      = coalesce(try(traffic_weight.value.percentage, null), 100)
      }
    }
  }

  # --- Secrets (Optional) ---
  dynamic "secret" {
    for_each = coalesce(try(each.value.secrets, []), [])
    content {
      name  = coalesce(try(secret.value.name, null), "")
      value = coalesce(try(secret.value.value, null), "")
    }
  }

  # --- Managed Identity ---
  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }

  lifecycle {
    ignore_changes = [
      template,
      ingress[0].traffic_weight,
    ]
  }

  depends_on = [
    var.environment_id,
    var.user_assigned_identity_id
  ]
}

# --- Diagnostics ---
module "diagnostics_ca" {
  for_each                   = azurerm_container_app.apps
  source                     = "../../helpers/a-diagnostics"
  resource_type              = "container_app"
  resource_name              = each.value.name
  target_resource_id         = each.value.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}
