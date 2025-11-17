variable "type" {
  description = "Naming case type: standard | extended | compact | connectivity | identity."
  type        = string

  validation {
    condition     = contains(["standard", "extended", "compact", "compact_extended", "connectivity", "identity"], var.type)
    error_message = "Invalid type. Must be one of: standard, extended, compact, compact_extended, connectivity, identity."
  }
}

# https://learn.microsoft.com/th-th/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
variable "abbr" {
  description = "Resource abbreviation, e.g. kv, vnet, app. Must follow CAF abbreviation guidelines."
  type        = string

  validation {
    condition = (
      can(regex("^([a-z]{2,7})$", var.abbr))
      &&
      contains([
        "rg", "vnet", "nsg", "nic", "kv", "vm", "app", "st", "acr", "func", "sql", "adf", "iot", "srch", "cosmos", "sp", "redis", "cae", "ca", "id", "log", "aadgrp"
      ], var.abbr)
    )
    error_message = "Invalid abbreviation '${var.abbr}'. Must be lowercase 2–7 letters and one of the allowed CAF abbreviations."
  }
}


variable "rootid" {
  description = "Root identifier for workload or platform (e.g., app1, platform)."
  type        = string
}

variable "component" {
  description = "Optional component or service name (for extended type)."
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment identifier, e.g., dev, stg, prd."
  type        = string
}

variable "purpose" {
  description = "Optional purpose (for connectivity type)."
  type        = string
  default     = null
}

variable "location" {
  description = "Azure region for deployment."
  type        = string
  default     = "germanywestcentral"
}

variable "index" {
  description = "Optional numeric index for duplicate resources."
  type        = string
  default     = ""
}