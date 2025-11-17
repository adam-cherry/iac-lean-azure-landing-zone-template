# --- Core Metadata ---
variable "app" {
  description = "Root ID (e.g. project or app identifier)"
  type        = string
}

variable "env" {
  description = "Environment (e.g. dev, test, prod)"
  type        = string
}

variable "app_index" {
  type        = string
  default     = "001"
  description = "Optional index for multiple ACA applications"
}

variable "resource_group_name" {
  description = "Target Resource Group for Container Apps"
  type        = string
}

variable "environment_id" {
  description = "ID of the Azure Container App Environment"
  type        = string
}

variable "user_assigned_identity_id" {
  description = "User-assigned Managed Identity ID used by the Container App"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace for diagnostics"
  type        = string
}

variable "resource_tags_default" {
  description = "Default tags applied to all resources"
  type        = map(string)
  default     = {}
}

# --- Application Definitions ---
variable "apps" {
  description = "Container App definitions"
  type = map(object({
    index         = optional(string, "001")
    revision_mode = optional(string)
    template = optional(object({
      image        = optional(string)
      cpu          = optional(number)
      memory       = optional(string)
      min_replicas = optional(number)
      max_replicas = optional(number)
    }))
    ingress = object({
      external_enabled = bool
      target_port      = number
      traffic_weight = list(object({
        latest_revision = bool
        percentage      = number
      }))
      transport = optional(string)
    })
    secrets = optional(list(object({
      name  = string
      value = string
    })))
  }))
}
