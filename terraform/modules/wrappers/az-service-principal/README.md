<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.00 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 3.00 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_naming_sp"></a> [naming\_sp](#module\_naming\_sp) | ../../helpers/a-naming | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_application.app](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_password.app_secret](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) | resource |
| [azuread_service_principal.sp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_key_vault_secret.secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app"></a> [app](#input\_app) | Root workload identifier (e.g., app1) | `string` | n/a | yes |
| <a name="input_app_logo_path"></a> [app\_logo\_path](#input\_app\_logo\_path) | Path to optional application logo | `string` | `null` | no |
| <a name="input_app_notes"></a> [app\_notes](#input\_app\_notes) | Notes for the app registration | `string` | `null` | no |
| <a name="input_app_owners"></a> [app\_owners](#input\_app\_owners) | List of owner object IDs (users or service principals) | `list(string)` | `[]` | no |
| <a name="input_app_required_resource_access"></a> [app\_required\_resource\_access](#input\_app\_required\_resource\_access) | List of resource API permissions for this app registration | <pre>list(object({<br/>    resource_app_id = string<br/>    resource_access = list(object({<br/>      id   = string<br/>      type = string<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment (dev\|stg\|prd) | `string` | n/a | yes |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | Optional Key Vault ID for storing the sp secret | `string` | `null` | no |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | Purpose for naming (e.g., shared, automation, app) | `string` | n/a | yes |
| <a name="input_sp_index"></a> [sp\_index](#input\_sp\_index) | Index for multiple sps of same purpose | `string` | `"001"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_client_id"></a> [app\_client\_id](#output\_app\_client\_id) | AzureAD App Registration Client ID |
| <a name="output_app_object_id"></a> [app\_object\_id](#output\_app\_object\_id) | AzureAD Application Object ID |
| <a name="output_keyvault_secret_id"></a> [keyvault\_secret\_id](#output\_keyvault\_secret\_id) | ID of the created secret in Key Vault (if any) |
| <a name="output_sp_object_id"></a> [sp\_object\_id](#output\_sp\_object\_id) | Service Principal Object ID |
<!-- END_TF_DOCS -->