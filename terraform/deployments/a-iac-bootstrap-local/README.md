# Local Bootstrap Deployment
## Migration and Management of the Terraform Backend in Azure

To solve the previously mentioned "chicken-and-egg" problem in Azure and store the backend state centrally and securely, the following steps are required:

1. In the `azure_backend` directory, after your initial deployment, you will find the file `terraform.tfstate`. Rename this file to `backend.tfstate`.

2. Log in to the Azure Portal and select the storage account that you previously deployed using Terraform.

3. Next, select the container `tf-state-level0` and upload the `backend.tfstate` file.

4. Now create a new file in your `azure_backend` folder named `backend.tf` with the following content:

```
terraform {
  backend "azurerm" {
    resource_group_name  = "app1-tfbootstrap"
    storage_account_name = "lmxbackendsa"
    container_name       = "tf-state-level0"
    key                  = "backend.tfstate"
  }
}
```

5. Please adjust the values (e.g., `storage_account_name`) according to your configuration.
6. You can now delete the `.tfstate` files and the `.terraform` folder located in `azure_backend`.
7. Run the following command to successfully initialize the backend:
   `terraform init -migrate-state`
8. With `terraform plan` you can verify that everything worked correctly. The output should look as expected.

---

**Congratulations!**
You have now successfully set up your standardized and Terraform-managed backend in Azure.

---

**Note:**
If you have specified your current IP address in the `settings.bootstrap.tf` file, you must regularly update it in the portal → **Storage Account → Networking** or enter your current IP address.
Otherwise, you will not have access to the Terraform state files.

---

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.00 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.00 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.6.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.50.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bootstrap_keyvault"></a> [bootstrap\_keyvault](#module\_bootstrap\_keyvault) | ../../modules/wrappers/az-keyvault | n/a |
| <a name="module_bootstrap_storage"></a> [bootstrap\_storage](#module\_bootstrap\_storage) | ../../modules/wrappers/az-storage-account | n/a |
| <a name="module_naming"></a> [naming](#module\_naming) | ../../modules/helpers/a-naming | n/a |
| <a name="module_naming_law"></a> [naming\_law](#module\_naming\_law) | ../../modules/helpers/a-naming | n/a |
| <a name="module_naming_rg"></a> [naming\_rg](#module\_naming\_rg) | ../../modules/helpers/a-naming | n/a |
| <a name="module_tf_pipeline_sp"></a> [tf\_pipeline\_sp](#module\_tf\_pipeline\_sp) | ../../modules/wrappers/az-service-principal | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_group.tf_ops](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
| [azuread_group_member.sp_member](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group_member) | resource |
| [azurerm_log_analytics_workspace.iac_law](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_resource_group.backend](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_provider_registration.required](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_provider_registration) | resource |
| [azurerm_role_assignment.sp_reader_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sp_storage_keys](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_resource_group_name"></a> [backend\_resource\_group\_name](#output\_backend\_resource\_group\_name) | Name of the bootstrap resource group |
| <a name="output_bootstrap_keyvault_id"></a> [bootstrap\_keyvault\_id](#output\_bootstrap\_keyvault\_id) | Resource ID of the bootstrap Key Vault |
| <a name="output_bootstrap_keyvault_name"></a> [bootstrap\_keyvault\_name](#output\_bootstrap\_keyvault\_name) | Name of the bootstrap Key Vault |
| <a name="output_bootstrap_keyvault_uri"></a> [bootstrap\_keyvault\_uri](#output\_bootstrap\_keyvault\_uri) | Vault URI of the bootstrap Key Vault |
| <a name="output_bootstrap_storage_account_id"></a> [bootstrap\_storage\_account\_id](#output\_bootstrap\_storage\_account\_id) | Resource ID of the bootstrap storage account |
| <a name="output_bootstrap_storage_account_name"></a> [bootstrap\_storage\_account\_name](#output\_bootstrap\_storage\_account\_name) | Name of the bootstrap storage account |
| <a name="output_location"></a> [location](#output\_location) | The project's primary Azure location. |
| <a name="output_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#output\_log\_analytics\_workspace\_name) | Name of the Log Analytics Workspace |
| <a name="output_pipeline_sp_client_id"></a> [pipeline\_sp\_client\_id](#output\_pipeline\_sp\_client\_id) | Terraform pipeline Service Principal Client ID |
| <a name="output_pipeline_sp_object_id"></a> [pipeline\_sp\_object\_id](#output\_pipeline\_sp\_object\_id) | Terraform pipeline Service Principal Object ID |
| <a name="output_pipeline_sp_secret_id"></a> [pipeline\_sp\_secret\_id](#output\_pipeline\_sp\_secret\_id) | ID of the stored sp secret in Key Vault |
| <a name="output_resource_default_tags"></a> [resource\_default\_tags](#output\_resource\_default\_tags) | A map of Tags that will be applied to Azure resources. |
| <a name="output_root_id"></a> [root\_id](#output\_root\_id) | The project's root id. |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | The ID for the core/Iac Azure subscription. |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | The Azure Tenant ID. |
| <a name="output_tf_ops_group"></a> [tf\_ops\_group](#output\_tf\_ops\_group) | Azure AD group object for Terraform Operations |
<!-- END_TF_DOCS -->