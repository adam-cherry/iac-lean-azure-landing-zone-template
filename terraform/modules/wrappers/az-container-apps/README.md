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
| <a name="module_diagnostics_ca"></a> [diagnostics\_ca](#module\_diagnostics\_ca) | ../../helpers/a-diagnostics | n/a |
| <a name="module_naming_ca"></a> [naming\_ca](#module\_naming\_ca) | ../../helpers/a-naming | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_container_app.apps](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app"></a> [app](#input\_app) | Root ID (e.g. project or app identifier) | `string` | n/a | yes |
| <a name="input_app_index"></a> [app\_index](#input\_app\_index) | Optional index for multiple ACA applications | `string` | `"001"` | no |
| <a name="input_apps"></a> [apps](#input\_apps) | Container App definitions | <pre>map(object({<br/>    index         = optional(string, "001")<br/>    revision_mode = optional(string)<br/>    template = optional(object({<br/>      image        = optional(string)<br/>      cpu          = optional(number)<br/>      memory       = optional(string)<br/>      min_replicas = optional(number)<br/>      max_replicas = optional(number)<br/>    }))<br/>    ingress = object({<br/>      external_enabled = bool<br/>      target_port      = number<br/>      traffic_weight = list(object({<br/>        latest_revision = bool<br/>        percentage      = number<br/>      }))<br/>      transport = optional(string)<br/>    })<br/>    secrets = optional(list(object({<br/>      name  = string<br/>      value = string<br/>    })))<br/>  }))</pre> | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment (e.g. dev, test, prod) | `string` | n/a | yes |
| <a name="input_environment_id"></a> [environment\_id](#input\_environment\_id) | ID of the Azure Container App Environment | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Log Analytics Workspace for diagnostics | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Target Resource Group for Container Apps | `string` | n/a | yes |
| <a name="input_resource_tags_default"></a> [resource\_tags\_default](#input\_resource\_tags\_default) | Default tags applied to all resources | `map(string)` | `{}` | no |
| <a name="input_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#input\_user\_assigned\_identity\_id) | User-assigned Managed Identity ID used by the Container App | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_app_fqdns"></a> [container\_app\_fqdns](#output\_container\_app\_fqdns) | FQDNs of all Container Apps (if ingress enabled) |
| <a name="output_container_app_ids"></a> [container\_app\_ids](#output\_container\_app\_ids) | Resource IDs of all Container Apps |
| <a name="output_container_app_names"></a> [container\_app\_names](#output\_container\_app\_names) | Names of all Container Apps |
<!-- END_TF_DOCS -->