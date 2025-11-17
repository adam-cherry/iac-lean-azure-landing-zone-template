# --- Resource Group ---
resource "azurerm_resource_group" "network" {
  name     = "rg-${local.root_id}-${local.environment}-net"
  location = local.location
  tags     = local.resource_tags_default
}


# --- VNET Module ---
# tfsec:ignore:azure-network-no-public-egress
module "vnet" {
  source = "../../modules/wrappers/az-virtual-network"

  app      = local.root_id
  env      = local.environment
  purpose  = "shared"
  location = local.location

  vnet_index                 = "001"
  resource_group_name        = azurerm_resource_group.network.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  address_space = [local.network.vnet_cidr]

  nsgs = {
    shared = {
      security_rules = [
        {
          name                       = "AllowHttpsOut"
          priority                   = 100
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
          description                = "Allow outbound HTTPS"
        }
      ]
    }
  }

  route_tables = {
    default = {
      routes = [ # Example route to send all traffic to a virtual appliance, be careful with this. It will block all outbound access. 
        {
          name                   = "DefaultToHub"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.0.0.4"
        }
      ]
    }
  }

  subnets = {
    compute = {
      address_prefixes  = [local.network.subnet_compute_cidr]
      nsg_key           = "shared"
      route_table_key   = "default"
      service_endpoints = ["Microsoft.Storage"]
    }
    persistence = {
      address_prefixes                  = [local.network.subnet_persistence_cidr]
      service_endpoints                 = ["Microsoft.Storage", "Microsoft.Sql"]
      private_endpoint_network_policies = "Disabled"
    }
    aca_infra = {
      address_prefixes = [local.network.subnet_apps_cidr] #Provided subnet must have a size of at least /23
      #delegations = ["Microsoft.App/environments"] will be added automatically by the cae ressource.

      private_endpoint_network_policies             = "Disabled"
      private_link_service_network_policies_enabled = false
      service_endpoints                             = []
      nsg_key                                       = "shared"
      #route_table_key   = "default" # At ACA setup and runtime, Azure needs outbound access to Microsoft services(Log Analytics, Storage, DNS, Container Registry, Control Plane) with dummy route table will block that.
    }
  }

  resource_tags_default = local.resource_tags_default
}

