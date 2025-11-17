# Storage Account Wrapper Module (Wattfox)

This module creates a storage account + optional container and automatically integrates naming + diagnostics according to Wattfox guidelines.

## Usage

```hcl
module "sa" {
  source = "git::ssh://…/modules/resource/storage_account.git"
  app                     = "app1"
  env                     = "prd"
  region                  = "weu"
  component               = "data"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location
  log_analytics_workspace_id = module.log_workspace.id

  account_kind            = "StorageV2"
  account_tier            = "Standard"
  access_tier             = "Hot"
  public_network_access_enabled = false
  default_action          = "Deny"
  bypass                  = ["Metrics", "Logging"]
  ip_rules                = []

  containers = {
    "data" = { public_access = "None" }
    "logs" = { public_access = "Blob" }
  }

  resource_tags_default = {
    project = "app1"
    env     = "prd"
  }
}
```
---
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_diagnostics"></a> [diagnostics](#module\_diagnostics) | ../../helpers/a-diagnostics | n/a |
| <a name="module_diagnostics_file"></a> [diagnostics\_file](#module\_diagnostics\_file) | ../../helpers/a-diagnostics | n/a |
| <a name="module_naming"></a> [naming](#module\_naming) | ../../helpers/a-naming | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | Access tier: Hot or Cool | `string` | `"Hot"` | no |
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | Kind of the storage account | `string` | `"StorageV2"` | no |
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | Storage account replication type | `string` | `"LRS"` | no |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | Storage account tier: Standard or Premium | `string` | `"Standard"` | no |
| <a name="input_allow_nested_items_to_be_public"></a> [allow\_nested\_items\_to\_be\_public](#input\_allow\_nested\_items\_to\_be\_public) | Allow nested items to opt into public access | `bool` | `false` | no |
| <a name="input_app"></a> [app](#input\_app) | Workload root id, e.g. app1 | `string` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | Component identifier, e.g. iac, app | `string` | n/a | yes |
| <a name="input_containers"></a> [containers](#input\_containers) | Containers to create: map(name => optional settings) e.g. { "data" = { public\_access = "None" }, "logs" = {} } | <pre>map(object({<br/>    public_access = optional(string) # "None", "Blob", "Container"<br/>  }))</pre> | `{}` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment identifier, e.g. dev, stg, prd | `string` | n/a | yes |
| <a name="input_last_access_time_enabled"></a> [last\_access\_time\_enabled](#input\_last\_access\_time\_enabled) | Enable last access time tracking for blobs | `bool` | `false` | no |
| <a name="input_lock"></a> [lock](#input\_lock) | Optional lock configuration for the storage account. Set via { name = ..., kind = ... } | <pre>object({<br/>    name = string<br/>    kind = string<br/>  })</pre> | `null` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Log Analytics workspace ID for diagnostics | `string` | n/a | yes |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | Minimum TLS version (TLS1\_2 only supported) | `string` | `"TLS1_2"` | no |
| <a name="input_network_rules"></a> [network\_rules](#input\_network\_rules) | Network ACL configuration for the Storage Account | <pre>object({<br/>    default_action             = optional(string, "Deny")<br/>    bypass                     = optional(list(string), ["Logging", "Metrics", "AzureServices"])<br/>    ip_rules                   = optional(list(string), [])<br/>    virtual_network_subnet_ids = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Enable public network access to storage account | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group to deploy the storage account into | `string` | n/a | yes |
| <a name="input_resource_tags_default"></a> [resource\_tags\_default](#input\_resource\_tags\_default) | Default tags to apply to the storage account | `map(string)` | `{}` | no |
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | Optional role assignments for the Storage Account (RBAC). | <pre>map(object({<br/>    role_definition_id_or_name       = string<br/>    principal_id                     = string<br/>    skip_service_principal_aad_check = optional(bool, true)<br/>    principal_type                   = optional(string, "ServicePrincipal")<br/>  }))</pre> | `{}` | no |
| <a name="input_st_index"></a> [st\_index](#input\_st\_index) | Index to allow multiple storage accounts per workload (0 for first) | `string` | `"001"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_names"></a> [container\_names](#output\_container\_names) | List of container names created |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | ID of the storage account |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | Name of the storage account |
<!-- END_TF_DOCS -->