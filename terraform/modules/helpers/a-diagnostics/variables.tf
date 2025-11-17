variable "target_resource_id" {
  description = "The ID of the Azure resource to attach diagnostic settings to."
  type        = string
}

variable "resource_name" {
  description = "The name of the Azure resource (used in diagnostic setting name)."
  type        = string
}

variable "resource_type" {
  description = "Short resource type key (e.g., firewall, key_vault, storage, containerapp, public_ip)."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "ID of the central Log Analytics workspace to send logs and metrics."
  type        = string
}

variable "metrics_enabled" {
  description = "Enable metrics collection (AllMetrics category)."
  type        = bool
  default     = true
}

variable "categories_override" {
  description = "Optional list of log categories to override defaults."
  type        = list(string)
  default     = []
}
