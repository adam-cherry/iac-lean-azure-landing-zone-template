variable "app" {
  type        = string
  description = "Root workload identifier (e.g., app1)"
}

variable "env" {
  type        = string
  description = "Environment (dev|stg|prd)"
}

variable "component" {
  type        = string
  description = "Component or purpose identifier for the Key Vault"
}

variable "kv_index" {
  type        = string
  description = "Optional index for multiple Key Vaults"
  default     = "001"
}

variable "resource_group_name" {
  type        = string
  description = "Target resource group for the Key Vault"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics workspace ID for diagnostics"
}

variable "location" {
  type        = string
  description = "Azure region for deployment"
  default     = "germanywestcentral"
}

variable "sku_name" {
  type        = string
  description = "Key Vault SKU: standard or premium"
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], lower(var.sku_name))
    error_message = "sku_name must be either 'standard' or 'premium'"
  }
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Retention days for soft delete"
  default     = 90
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Enable purge protection"
  default     = true
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Allow public network access"
  default     = false
}

variable "network_acls" {
  description = "Network ACL configuration for Key Vault"
  type = object({
    default_action             = optional(string, "Deny")
    bypass                     = optional(string, "AzureServices")
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default = null
}

variable "resource_tags_default" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name       = string
    principal_id                     = string
    skip_service_principal_aad_check = optional(bool, true)
    principal_type                   = optional(string, "ServicePrincipal")
  }))
  default     = {}
  description = "Optional role assignments for Key Vault (RBAC)."
}