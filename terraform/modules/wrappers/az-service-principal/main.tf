# --- Naming (Identity schema) ---
module "naming_sp" {
  source      = "../../helpers/a-naming"
  type        = "identity"
  abbr        = "sp"
  purpose     = var.purpose
  index       = var.sp_index
  environment = var.env
  rootid      = var.app
}

# --- Application Registration ---
resource "azuread_application" "app" {
  display_name = local.module_naming.name
  logo_image   = local.app_logo_image
  notes        = var.app_notes != null ? var.app_notes : null
  owners       = var.app_owners

  dynamic "required_resource_access" {
    for_each = var.app_required_resource_access
    content {
      resource_app_id = required_resource_access.value.resource_app_id
      dynamic "resource_access" {
        for_each = required_resource_access.value.resource_access
        content {
          id   = resource_access.value.id
          type = resource_access.value.type
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [owners]
  }
}

# --- Service Principal ---
resource "azuread_service_principal" "sp" {
  client_id = azuread_application.app.client_id
  owners    = var.app_owners
}

# --- Application Secret ---
resource "azuread_application_password" "app_secret" {
  display_name   = local.app_secret_name
  application_id = azuread_application.app.id
}

resource "azurerm_key_vault_secret" "secret" {
  key_vault_id    = var.key_vault_id
  name            = local.app_secret_name
  value           = azuread_application_password.app_secret.value
  expiration_date = azuread_application_password.app_secret.end_date
  content_type    = "password"

  lifecycle {
    ignore_changes = [
      expiration_date
    ]
  }
}