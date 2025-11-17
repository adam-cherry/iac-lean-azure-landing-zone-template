 # 🧱 Azure Virtual Network Wrapper Module

This module creates a **complete VNet connectivity layer** in Azure:
Virtual Network, Subnets, Network Security Groups, Route Tables, and optional Diagnostics.
It is designed to remain reusable in **enterprise or landing zone environments**.


---

## 🧩 Usage

```hcl
module "vnet" {
  source = "../../modules/wrappers/az-virtual-network"

  app                  = "vgw"
  env                  = "dev"
  purpose              = "shared"
  region               = "weu"
  resource_group_name  = "rg-poc-test-net"
  log_analytics_workspace_id = "/subscriptions/.../workspaces/law-shared"

  address_space = ["10.0.0.0/16"]

  nsgs = {
    shared = {
      security_rules = [
        {
          name                      = "AllowHttpsOut"
          priority                  = 100
          direction                 = "Outbound"
          access                    = "Allow"
          protocol                  = "Tcp"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
          description                = "Allow outbound HTTPS"
        }
      ]
    }
  }

  subnets = {
    compute = {
      address_prefixes = ["10.0.1.0/24"]
      nsg_key          = "shared"
    }
  }

  resource_tags_default = {
    environment = "dev"
    owner       = "cloud-team"
  }
}
```

---

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.0 |
| <a name="provider_time"></a> [time](#provider\_time) | >= 0.10.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_diagnostics_nsg"></a> [diagnostics\_nsg](#module\_diagnostics\_nsg) | ../../helpers/a-diagnostics | n/a |
| <a name="module_naming_nsg"></a> [naming\_nsg](#module\_naming\_nsg) | ../../helpers/a-naming | n/a |
| <a name="module_naming_vnet"></a> [naming\_vnet](#module\_naming\_vnet) | ../../helpers/a-naming | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_route_table.rt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.subnet_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.subnet_rt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [time_sleep.after_vnet](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | VNet CIDR ranges | `list(string)` | n/a | yes |
| <a name="input_app"></a> [app](#input\_app) | Root workload ID, e.g. app1 | `string` | n/a | yes |
| <a name="input_bgp_community"></a> [bgp\_community](#input\_bgp\_community) | Optional BGP community | `string` | `null` | no |
| <a name="input_ddos_protection_plan_id"></a> [ddos\_protection\_plan\_id](#input\_ddos\_protection\_plan\_id) | Optional DDoS plan ID | `string` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment (dev\|stg\|prd) | `string` | n/a | yes |
| <a name="input_flow_timeout_in_minutes"></a> [flow\_timeout\_in\_minutes](#input\_flow\_timeout\_in\_minutes) | VNet flow timeout (minutes) | `number` | `4` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region | `string` | `"germanywestcentral"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | LAW ID for diagnostics | `string` | n/a | yes |
| <a name="input_nsg_diagnostics_categories"></a> [nsg\_diagnostics\_categories](#input\_nsg\_diagnostics\_categories) | Optional override for NSG diagnostics | `list(string)` | `[]` | no |
| <a name="input_nsgs"></a> [nsgs](#input\_nsgs) | n/a | <pre>map(object({<br/>    name = optional(string)<br/>    security_rules = optional(list(object({<br/>      name                       = string<br/>      priority                   = number<br/>      direction                  = string<br/>      access                     = string<br/>      protocol                   = string<br/>      source_port_range          = optional(string)<br/>      destination_port_range     = optional(string)<br/>      source_address_prefix      = optional(string)<br/>      destination_address_prefix = optional(string)<br/>      description                = optional(string)<br/>    })))<br/>  }))</pre> | `{}` | no |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | Purpose for connectivity naming, e.g. shared, spoke, hub | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Target Resource Group | `string` | n/a | yes |
| <a name="input_resource_tags_default"></a> [resource\_tags\_default](#input\_resource\_tags\_default) | Default governance tags | `map(string)` | `{}` | no |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | n/a | <pre>map(object({<br/>    name                          = optional(string)<br/>    disable_bgp_route_propagation = optional(bool)<br/>    routes = optional(list(object({<br/>      name                   = string<br/>      address_prefix         = string<br/>      next_hop_type          = string<br/>      next_hop_in_ip_address = optional(string)<br/>    })))<br/>  }))</pre> | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | n/a | <pre>map(object({<br/>    name                                          = optional(string)<br/>    address_prefixes                              = list(string)<br/>    service_endpoints                             = optional(list(string))<br/>    delegations                                   = optional(list(string))<br/>    private_endpoint_network_policies             = optional(string)<br/>    private_link_service_network_policies_enabled = optional(bool)<br/>    nsg_key                                       = optional(string)<br/>    route_table_key                               = optional(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_vnet_index"></a> [vnet\_index](#input\_vnet\_index) | Index for multiple VNets | `string` | `"001"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nsg_ids"></a> [nsg\_ids](#output\_nsg\_ids) | Map of NSG IDs by key |
| <a name="output_route_table_ids"></a> [route\_table\_ids](#output\_route\_table\_ids) | Map of route table IDs by key |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Map of subnet IDs by key |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | VNet resource ID |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | VNet name |
<!-- END_TF_DOCS -->