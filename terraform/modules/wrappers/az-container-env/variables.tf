variable "app" {
  type        = string
  description = "Root workload identifier (e.g. app1)"
}

variable "env" {
  type        = string
  description = "Environment (dev|stg|prd)"
}

variable "env_index" {
  type        = string
  default     = "001"
  description = "Optional index for multiple ACA environments"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for ACA environment"
}

variable "location" {
  type        = string
  default     = "germanywestcentral"
  description = "Azure region for ACA environment"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID"
}

variable "infrastructure_subnet_id" {
  type        = string
  description = "Subnet ID for ACA environment infrastructure"
}

variable "internal_load_balancer_enabled" {
  type        = bool
  default     = true
  description = "Enable internal load balancer (private ingress)"
}

variable "zone_redundancy_enabled" {
  type        = bool
  default     = false
  description = "Enable zone redundancy"
}

variable "workload_profile" {
  description = "Optional list of workload profiles"
  type = list(object({
    name                  = string
    workload_profile_type = string
    minimum_count         = number
    maximum_count         = number
  }))
  default = []
}

variable "resource_tags_default" {
  type        = map(string)
  default     = {}
  description = "Default governance tags"
}
