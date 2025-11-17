# tflint-ignore: terraform_unused_declarations
variable "root_id" {
  type        = string
  description = "If specified, will set a custom Name (ID) value and append this to the ID for all core Enterprise-scale Ressources."
}

variable "location" {
  type        = string
  default     = "germanywestcentral"
  description = "Azure region (primary)"
}

variable "tenant_id" {
  type        = string
  description = "The ID for our Microsoft Entra ID tenant."
}
variable "subscription_id" {
  type        = string
  description = "If specified, identifies the subscription for resource deployment"
}

# tflint-ignore: terraform_unused_declarations
variable "resource_tags_default" {
  type        = map(string)
  description = "A map of Tags that will be applied to Azure resources, e.g. 'project' or 'cost-center'."
}
