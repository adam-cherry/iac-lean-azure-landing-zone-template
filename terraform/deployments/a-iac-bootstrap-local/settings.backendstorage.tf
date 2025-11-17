locals {
  backend_lock = {
    name = "Do not delete bootstrap resources"
    kind = "CanNotDelete"
  }
  # Enable Network Rules for only trusted IPs and subnets
  # tflint-ignore: terraform_unused_declarations
  backend_network_rules = {
    # bypass                     = ["AzureServices"]
    # default_action             = "Deny"
    # ip_rules                   = var.backend_ip_rules
    # virtual_network_subnet_ids = var.backend_subnet_ids
  }

  # Blob Contributor for L0 sp on storage account level
  backend_storage_role_assignments = {
    role_assignment_local = {
      role_definition_id_or_name       = "Storage Blob Data Contributor"
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = true
      principal_type                   = "User"
    }
    role_assignment_sp = {
      role_definition_id_or_name       = "Storage Blob Data Contributor"
      principal_id                     = module.tf_pipeline_sp.sp_object_id
      skip_service_principal_aad_check = true
      principal_type                   = "ServicePrincipal"
    }
  }

  # One blob container per level
  backend_containers = {
    tf-state-level0 = {
      container_access_type = "private"
    }
    tf-state-level1 = {
      container_access_type = "private"
    }
    tf-state-level2 = {
      container_access_type = "private"
    }
  }
}
