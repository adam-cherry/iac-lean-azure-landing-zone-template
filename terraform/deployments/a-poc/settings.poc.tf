locals {
  # Global context
  root_id         = "poc"
  tenant_id       = "XXXXXXXXXXXXXXXX"
  subscription_id = "XXXXXXXXXXXXXXXX"
  location        = "germanywestcentral"
  environment     = "dev"

  # Standard Tags
  resource_tags_default = {
    company              = "acompany"
    created-by           = "Adam Kirschstein"
    managed-by-terraform = "true"
    project              = "aproject"
  }

  # Network Configuration
  network = {
    vnet_cidr               = "10.60.0.0/16"
    subnet_compute_cidr     = "10.60.1.0/24" #https://registry.terraform.io/modules/hashicorp/subnets/cidr/latest
    subnet_persistence_cidr = "10.60.2.0/24"
    subnet_apps_cidr        = "10.60.4.0/23"
  }

  # Container Apps Configuration
  apps = {
    frontend = {
      revision_mode = "Single"
      ingress = {
        external_enabled = true
        target_port      = 80
        traffic_weight = [
          {
            latest_revision = true
            percentage      = 100
          }
        ]
      }
    }

    api = {
      revision_mode = "Single"
      ingress = {
        external_enabled = false
        target_port      = 80
        traffic_weight = [
          {
            latest_revision = true
            percentage      = 100
          }
        ]
      }
    }
  }

  # Optional integrations
  # tflint-ignore: terraform_unused_declarations
  acr_id = null
}
