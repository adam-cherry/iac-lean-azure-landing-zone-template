variable "app" {
  type        = string
  description = "Root workload ID, e.g. app1"
}

variable "env" {
  type        = string
  description = "Environment (dev|stg|prd)"
}

variable "purpose" {
  type        = string
  description = "Purpose for connectivity naming, e.g. shared, spoke, hub"
}
variable "location" {
  type        = string
  description = "Azure region"
  default     = "germanywestcentral"
}

variable "vnet_index" {
  type        = string
  description = "Index for multiple VNets"
  default     = "001"
}

variable "resource_group_name" {
  type        = string
  description = "Target Resource Group"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "LAW ID for diagnostics"
}

variable "address_space" {
  type        = list(string)
  description = "VNet CIDR ranges"
}

variable "bgp_community" {
  type        = string
  description = "Optional BGP community"
  default     = null
}

variable "ddos_protection_plan_id" {
  type        = string
  description = "Optional DDoS plan ID"
  default     = null
}

variable "flow_timeout_in_minutes" {
  type        = number
  description = "VNet flow timeout (minutes)"
  default     = 4
}

variable "route_tables" {
  type = map(object({
    name                          = optional(string)
    disable_bgp_route_propagation = optional(bool)
    routes = optional(list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })))
  }))
  default = {}
}

variable "nsgs" {
  type = map(object({
    name = optional(string)
    security_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string)
      destination_port_range     = optional(string)
      source_address_prefix      = optional(string)
      destination_address_prefix = optional(string)
      description                = optional(string)
    })))
  }))
  default = {}
}

variable "subnets" {
  type = map(object({
    name                                          = optional(string)
    address_prefixes                              = list(string)
    service_endpoints                             = optional(list(string))
    delegations                                   = optional(list(string))
    private_endpoint_network_policies             = optional(string)
    private_link_service_network_policies_enabled = optional(bool)
    nsg_key                                       = optional(string)
    route_table_key                               = optional(string)
  }))
}

variable "resource_tags_default" {
  type        = map(string)
  description = "Default governance tags"
  default     = {}
}

variable "nsg_diagnostics_categories" {
  type        = list(string)
  description = "Optional override for NSG diagnostics"
  default     = []
}
