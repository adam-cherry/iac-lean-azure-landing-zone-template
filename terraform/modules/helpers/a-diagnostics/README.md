# 🧩 A Diagnostics Module

This module configures **Azure Monitor Diagnostic Settings** for any resource,  
enforcing centralized logging and metrics to a shared Log Analytics workspace.

---

## ⚙️ Usage Example

```hcl
module "kv_diag" {
  source                    = "../../modules/helpers/a-diagnostics"
  resource_type              = "key_vault"
  resource_name              = azurerm_key_vault.main.name
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = module.log_workspace.id
}
````

**Result:**
A diagnostic setting named `diag-<resource>` with the relevant log categories and metrics enabled.

---

## 🧩 Supported Resource Types

| Type           | Enabled Log Categories                                                        |
| -------------- | ----------------------------------------------------------------------------- |
| `firewall`     | AzureFirewallApplicationRule, AzureFirewallNetworkRule, AzureFirewallDnsProxy |
| `public_ip`    | DDoSProtectionNotifications, DDoSMitigationFlowLogs, DDoSMitigationReports    |
| `key_vault`    | AuditEvent                                                                    |
| `storage`      | StorageRead, StorageWrite, StorageDelete                                      |
| `containerapp` | AppLogs, SystemLogs                                                           |
| `sql_server`   | SQLSecurityAuditEvents, AutomaticTuning, QueryStoreRuntimeStatistics, Errors  |
| `app_service`  | AppServiceHTTPLogs, AppServiceConsoleLogs, AppServiceAppLogs                  |
| `redis`        | ConnectedClientList, RedisServerLoad                                          |

You can override these defaults with `categories_override`.

---

## 📈 Metrics

All resources use the default **`AllMetrics`** category to enable complete telemetry collection.
This provides CPU, throughput, latency, and other platform metrics without additional configuration.
If granular control is needed, metrics can be disabled or overridden using:

```hcl
metrics_enabled = false
# or
metric_categories_override = ["SpecificCategory"]
```

> For most Azure resources, `AllMetrics` is sufficient and aligns with CAF recommendations.

---

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.00 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.00 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_categories_override"></a> [categories\_override](#input\_categories\_override) | Optional list of log categories to override defaults. | `list(string)` | `[]` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | ID of the central Log Analytics workspace to send logs and metrics. | `string` | n/a | yes |
| <a name="input_metrics_enabled"></a> [metrics\_enabled](#input\_metrics\_enabled) | Enable metrics collection (AllMetrics category). | `bool` | `true` | no |
| <a name="input_resource_name"></a> [resource\_name](#input\_resource\_name) | The name of the Azure resource (used in diagnostic setting name). | `string` | n/a | yes |
| <a name="input_resource_type"></a> [resource\_type](#input\_resource\_type) | Short resource type key (e.g., firewall, key\_vault, storage, containerapp, public\_ip). | `string` | n/a | yes |
| <a name="input_target_resource_id"></a> [target\_resource\_id](#input\_target\_resource\_id) | The ID of the Azure resource to attach diagnostic settings to. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_categories_enabled"></a> [categories\_enabled](#output\_categories\_enabled) | List of enabled log categories. |
| <a name="output_diagnostic_setting_name"></a> [diagnostic\_setting\_name](#output\_diagnostic\_setting\_name) | The name of the created diagnostic setting. |
<!-- END_TF_DOCS -->