<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.00 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Azure region (primary) | `string` | `"germanywestcentral"` | no |
| <a name="input_resource_tags_default"></a> [resource\_tags\_default](#input\_resource\_tags\_default) | A map of Tags that will be applied to Azure resources, e.g. 'project' or 'cost-center'. | `map(string)` | n/a | yes |
| <a name="input_root_id"></a> [root\_id](#input\_root\_id) | If specified, will set a custom Name (ID) value and append this to the ID for all core Enterprise-scale Ressources. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | If specified, identifies the subscription for resource deployment | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The ID for our Microsoft Entra ID tenant. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_location"></a> [location](#output\_location) | n/a |
<!-- END_TF_DOCS -->