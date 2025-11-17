variable "app" {
  type        = string
  description = "Root workload identifier (e.g., app1)"
}

variable "env" {
  type        = string
  description = "Environment (dev|stg|prd)"
}

variable "purpose" {
  type        = string
  description = "Purpose for naming (e.g., shared, automation, app)"
}

variable "sp_index" {
  type        = string
  default     = "001"
  description = "Index for multiple sps of same purpose"
}

variable "app_notes" {
  type        = string
  description = "Notes for the app registration"
  default     = null
}

variable "app_logo_path" {
  type        = string
  default     = null
  description = "Path to optional application logo"
}

variable "app_owners" {
  type        = list(string)
  default     = []
  description = "List of owner object IDs (users or service principals)"
}

variable "app_required_resource_access" {
  type = list(object({
    resource_app_id = string
    resource_access = list(object({
      id   = string
      type = string
    }))
  }))
  default     = []
  description = "List of resource API permissions for this app registration"
}

variable "key_vault_id" {
  type        = string
  default     = null
  description = "Optional Key Vault ID for storing the sp secret"
}