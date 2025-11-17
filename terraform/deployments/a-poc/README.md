<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.00 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.48.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aca_apps"></a> [aca\_apps](#module\_aca\_apps) | ../../modules/wrappers/az-container-apps | n/a |
| <a name="module_aca_env_poc"></a> [aca\_env\_poc](#module\_aca\_env\_poc) | ../../modules/wrappers/az-container-env | n/a |
| <a name="module_keyvault"></a> [keyvault](#module\_keyvault) | ../../modules/wrappers/az-keyvault | n/a |
| <a name="module_naming"></a> [naming](#module\_naming) | ../../modules/helpers/a-naming | n/a |
| <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account) | ../../modules/wrappers/az-storage-account | n/a |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | ../../modules/wrappers/az-virtual-network | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_workspace.law](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_resource_group.backend](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_user_assigned_identity.uami](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_example_name"></a> [example\_name](#output\_example\_name) | n/a |
| <a name="output_location"></a> [location](#output\_location) | n/a |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | n/a |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | n/a |
<!-- END_TF_DOCS -->