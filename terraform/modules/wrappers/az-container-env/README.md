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
| <a name="module_naming_aca_env"></a> [naming\_aca\_env](#module\_naming\_aca\_env) | ../../helpers/a-naming | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_container_app_environment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app"></a> [app](#input\_app) | Root workload identifier (e.g. app1) | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment (dev\|stg\|prd) | `string` | n/a | yes |
| <a name="input_env_index"></a> [env\_index](#input\_env\_index) | Optional index for multiple ACA environments | `string` | `"001"` | no |
| <a name="input_infrastructure_subnet_id"></a> [infrastructure\_subnet\_id](#input\_infrastructure\_subnet\_id) | Subnet ID for ACA environment infrastructure | `string` | n/a | yes |
| <a name="input_internal_load_balancer_enabled"></a> [internal\_load\_balancer\_enabled](#input\_internal\_load\_balancer\_enabled) | Enable internal load balancer (private ingress) | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for ACA environment | `string` | `"germanywestcentral"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Log Analytics Workspace ID | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name for ACA environment | `string` | n/a | yes |
| <a name="input_resource_tags_default"></a> [resource\_tags\_default](#input\_resource\_tags\_default) | Default governance tags | `map(string)` | `{}` | no |
| <a name="input_workload_profile"></a> [workload\_profile](#input\_workload\_profile) | Optional list of workload profiles | <pre>list(object({<br/>    name                  = string<br/>    workload_profile_type = string<br/>    minimum_count         = number<br/>    maximum_count         = number<br/>  }))</pre> | `[]` | no |
| <a name="input_zone_redundancy_enabled"></a> [zone\_redundancy\_enabled](#input\_zone\_redundancy\_enabled) | Enable zone redundancy | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aca_environment_id"></a> [aca\_environment\_id](#output\_aca\_environment\_id) | Resource ID of the Container Apps Environment |
| <a name="output_aca_environment_name"></a> [aca\_environment\_name](#output\_aca\_environment\_name) | Name of the Container Apps Environment |
| <a name="output_aca_environment_static_ip"></a> [aca\_environment\_static\_ip](#output\_aca\_environment\_static\_ip) | Static IP of the Container Apps Environment |
<!-- END_TF_DOCS -->