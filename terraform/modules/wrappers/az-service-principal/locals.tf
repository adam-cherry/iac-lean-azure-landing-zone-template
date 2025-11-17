locals {
  app_logo_image = var.app_logo_path == null ? null : filebase64(var.app_logo_path)

  # Example output: sp-devops-dev-001
  module_naming = {
    name = module.naming_sp.name
  }

  # Secret name in Key Vault: "sp-devops-dev-001"
  app_secret_name = module.naming_sp.name
}
