<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_diagnostics"></a> [diagnostics](#module\_diagnostics) | ../../helpers/a-diagnostics | n/a |
| <a name="module_naming_kv"></a> [naming\_kv](#module\_naming\_kv) | ../../helpers/a-naming | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app"></a> [app](#input\_app) | Root workload identifier (e.g., app1) | `string` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | Component or purpose identifier for the Key Vault | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment (dev\|stg\|prd) | `string` | n/a | yes |
| <a name="input_kv_index"></a> [kv\_index](#input\_kv\_index) | Optional index for multiple Key Vaults | `string` | `"001"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for deployment | `string` | `"germanywestcentral"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Log Analytics workspace ID for diagnostics | `string` | n/a | yes |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | Network ACL configuration for Key Vault | <pre>object({<br/>    default_action             = optional(string, "Deny")<br/>    bypass                     = optional(string, "AzureServices")<br/>    ip_rules                   = optional(list(string), [])<br/>    virtual_network_subnet_ids = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Allow public network access | `bool` | `false` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | Enable purge protection | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Target resource group for the Key Vault | `string` | n/a | yes |
| <a name="input_resource_tags_default"></a> [resource\_tags\_default](#input\_resource\_tags\_default) | Tags applied to all resources | `map(string)` | `{}` | no |
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | Optional role assignments for Key Vault (RBAC). | <pre>map(object({<br/>    role_definition_id_or_name       = string<br/>    principal_id                     = string<br/>    skip_service_principal_aad_check = optional(bool, true)<br/>    principal_type                   = optional(string, "ServicePrincipal")<br/>  }))</pre> | `{}` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Key Vault SKU: standard or premium | `string` | `"standard"` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | Retention days for soft delete | `number` | `90` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | Key Vault Resource ID |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | Key Vault name |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | Key Vault URI (DNS name) |
<!-- END_TF_DOCS -->