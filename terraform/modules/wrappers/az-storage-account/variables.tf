variable "app" {
  type        = string
  description = "Workload root id, e.g. app1"
}
variable "env" {
  type        = string
  description = "Environment identifier, e.g. dev, stg, prd"
}

variable "component" {
  type        = string
  description = "Component identifier, e.g. iac, app"
}

variable "st_index" {
  type        = string
  description = "Index to allow multiple storage accounts per workload (0 for first)"
  default     = "001"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy the storage account into"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics workspace ID for diagnostics"
}

variable "account_tier" {
  type        = string
  description = "Storage account tier: Standard or Premium"
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "account_tier must be Standard or Premium"
  }
}

variable "account_replication_type" {
  type        = string
  description = "Storage account replication type"
  default     = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "account_replication_type must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS"
  }
}

variable "account_kind" {
  type        = string
  description = "Kind of the storage account"
  default     = "StorageV2"
  validation {
    condition     = contains(["Storage", "StorageV2", "BlobStorage", "BlockBlobStorage", "FileStorage"], var.account_kind)
    error_message = "Invalid account_kind"
  }
}

variable "access_tier" {
  type        = string
  description = "Access tier: Hot or Cool"
  default     = "Hot"
  validation {
    condition     = contains(["Hot", "Cool"], var.access_tier)
    error_message = "access_tier must be Hot or Cool"
  }
}

variable "min_tls_version" {
  type        = string
  description = "Minimum TLS version (TLS1_2 only supported)"
  default     = "TLS1_2"
  validation {
    condition     = var.min_tls_version == "TLS1_2"
    error_message = "Only TLS1_2 is supported"
  }
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Enable public network access to storage account"
  default     = false
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  description = "Allow nested items to opt into public access"
  default     = false
}

variable "network_rules" {
  description = "Network ACL configuration for the Storage Account"
  type = object({
    default_action             = optional(string, "Deny")
    bypass                     = optional(list(string), ["Logging", "Metrics", "AzureServices"])
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default = null
}

# Containers to create: map(name => optional settings)
# e.g. { "data" = { public_access = "None" }, "logs" = {} }
variable "containers" {
  type = map(object({
    public_access = optional(string) # "None", "Blob", "Container"
  }))
  default = {}
}

variable "resource_tags_default" {
  type        = map(string)
  description = "Default tags to apply to the storage account"
  default     = {}
}


# Optional last access tracking
variable "last_access_time_enabled" {
  type        = bool
  description = "Enable last access time tracking for blobs"
  default     = false
}

variable "role_assignments" {
  description = "Optional role assignments for the Storage Account (RBAC)."
  type = map(object({
    role_definition_id_or_name       = string
    principal_id                     = string
    skip_service_principal_aad_check = optional(bool, true)
    principal_type                   = optional(string, "ServicePrincipal")
  }))
  default = {}
}

variable "lock" {
  description = "Optional lock configuration for the storage account. Set via { name = ..., kind = ... }"
  type = object({
    name = string
    kind = string
  })
  default = null
}