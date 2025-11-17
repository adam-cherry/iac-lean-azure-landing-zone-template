# --- Naming (Connectivity schema: <abbr>-<purpose>-<region>-<index>) ---
module "naming_vnet" {
  source      = "../../helpers/a-naming"
  type        = "connectivity"
  abbr        = "vnet"
  purpose     = var.purpose
  index       = var.vnet_index
  environment = var.env
  rootid      = var.app
  location    = var.location
}

resource "azurerm_virtual_network" "this" {
  name                = module.naming_vnet.name
  resource_group_name = var.resource_group_name
  location            = local.location
  address_space       = var.address_space
  bgp_community       = var.bgp_community

  flow_timeout_in_minutes = var.flow_timeout_in_minutes

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan_id != null ? [1] : []
    content {
      id     = var.ddos_protection_plan_id
      enable = true
    }
  }
  tags = var.resource_tags_default
}

# --- Wait resource to enforce Azure propagation ---
resource "time_sleep" "after_vnet" {
  depends_on      = [azurerm_virtual_network.this]
  create_duration = "15s"
}

# --- Subnets ---
resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                                          = coalesce(each.value.name, each.key)
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = each.value.address_prefixes
  service_endpoints                             = coalesce(each.value.service_endpoints, [])
  private_endpoint_network_policies             = coalesce(each.value.private_endpoint_network_policies, "Disabled")
  private_link_service_network_policies_enabled = coalesce(each.value.private_link_service_network_policies_enabled, false)

  dynamic "delegation" {
    for_each = coalesce(each.value.delegations, [])
    content {
      name = "${each.key}-delegation-${delegation.key}"
      service_delegation {
        name = delegation.value
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"
        ]
      }
    }
  }

  lifecycle {
    ignore_changes = [
      delegation[0].service_delegation[0].actions
    ]
  }

  depends_on = [
    azurerm_virtual_network.this,
    time_sleep.after_vnet
  ]
}

# --- Route Tables ---
resource "azurerm_route_table" "rt" {
  for_each            = var.route_tables
  name                = coalesce(each.value.name, "${module.naming_vnet.name}-rt-${each.key}")
  resource_group_name = var.resource_group_name
  location            = local.location

  dynamic "route" {
    for_each = coalesce(each.value.routes, [])
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = try(route.value.next_hop_in_ip_address, null)
    }
  }

  tags = var.resource_tags_default
}

# --- NSGs ---
module "naming_nsg" {
  source      = "../../helpers/a-naming"
  type        = "connectivity"
  abbr        = "nsg"
  purpose     = var.purpose
  location    = var.location
  index       = var.vnet_index
  environment = var.env
  rootid      = var.app
}


# --- NSG base resources ---
resource "azurerm_network_security_group" "nsg" {
  for_each            = var.nsgs
  name                = coalesce(each.value.name, "${module.naming_nsg.name}-${each.key}")
  resource_group_name = var.resource_group_name
  location            = local.location
  tags                = var.resource_tags_default
}

# --- NSG rules per NSG ---
resource "azurerm_network_security_rule" "rules" {
  for_each = { for item in local.nsg_rules_flat : item.key => item }

  name      = each.value.rule.name
  priority  = each.value.rule.priority
  direction = each.value.rule.direction
  access    = each.value.rule.access
  protocol  = each.value.rule.protocol

  # --- Ports ---
  source_port_range      = coalesce(try(each.value.rule.source_port_range, "*"), "*")
  destination_port_range = coalesce(try(each.value.rule.destination_port_range, "*"), "*")

  # --- Prefixes ---
  source_address_prefix      = coalesce(try(each.value.rule.source_address_prefix, "*"), "*")
  destination_address_prefix = coalesce(try(each.value.rule.destination_address_prefix, "*"), "*")

  # --- Optional description ---
  description = coalesce(try(each.value.rule.description, ""), "")

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg[each.value.nsg_key].name

  depends_on = [azurerm_network_security_group.nsg]
}





# --- Associations (Subnet ↔ NSG / Route Table) ---
resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  for_each                  = { for k, s in var.subnets : k => s if try(s.nsg_key != null, false) }
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[var.subnets[each.key].nsg_key].id

  depends_on = [
    azurerm_network_security_group.nsg,
    azurerm_subnet.subnet
  ]
}

resource "azurerm_subnet_route_table_association" "subnet_rt" {
  for_each       = { for k, s in var.subnets : k => s if try(s.route_table_key != null, false) }
  subnet_id      = azurerm_subnet.subnet[each.key].id
  route_table_id = azurerm_route_table.rt[var.subnets[each.key].route_table_key].id

  depends_on = [
    azurerm_route_table.rt,
    azurerm_subnet.subnet
  ]
}

# --- Diagnostics (only NSGs, not VNet) ---
module "diagnostics_nsg" {
  for_each                   = azurerm_network_security_group.nsg
  source                     = "../../helpers/a-diagnostics"
  resource_type              = "nsg"
  resource_name              = each.value.name
  target_resource_id         = each.value.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  categories_override        = var.nsg_diagnostics_categories
  metrics_enabled            = false

  depends_on = [
    azurerm_network_security_group.nsg,
    time_sleep.after_vnet
  ]

}