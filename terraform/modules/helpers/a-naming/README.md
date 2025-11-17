# 🧩 A Naming Module

The **`a-naming`** module enforces the acompany Azure resource naming convention.  
It generates CAF-aligned, consistent, and lowercase resource names across all deployments.

---

## ⚙️ Supported Naming Types

| Type | Format | Example | Description |
|------|---------|----------|-------------|
| **standard** | `<abbr>-<rootid>-<env>[-<index>]` | `kv-app1-prd-001` | Default for most resources (VMs, KV, SQL, Redis, etc.) |
| **extended** | `<abbr>-<rootid>-<component>-<env>[-<index>]` | `app-app1-api-dev-001` | For apps with multiple components (API, worker, etc.) |
| **compact** | `<abbr><rootid><env>[<index>]` | `crlmxprd001` | For global DNS-sensitive resources (Storage, ACR, Cosmos) |
| **connectivity** | `<abbr>-<purpose>-<region>[-<index>]` | `vgw-shared-weu-001` | For network or cross-region resources (Gateways, Connections) |

---

## 🧠 General Rules

- All names are **lowercase**, **max 24 chars**, and use **hyphens** except `compact`.  
- `index` is optional and only used for duplicate resources (e.g., Blue/Green).  
- If `index` is empty, the name automatically omits it.  
- CAF abbreviations are validated (e.g., `kv`, `vm`, `vnet`, `rg`, `cr`, `acr`, etc.).

---

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
| <a name="input_abbr"></a> [abbr](#input\_abbr) | Resource abbreviation, e.g. kv, vnet, app. Must follow CAF abbreviation guidelines. | `string` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | Optional component or service name (for extended type). | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment identifier, e.g., dev, stg, prd. | `string` | n/a | yes |
| <a name="input_index"></a> [index](#input\_index) | Optional numeric index for duplicate resources. | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for deployment. | `string` | `"germanywestcentral"` | no |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | Optional purpose (for connectivity type). | `string` | `null` | no |
| <a name="input_rootid"></a> [rootid](#input\_rootid) | Root identifier for workload or platform (e.g., app1, platform). | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Naming case type: standard \| extended \| compact \| connectivity \| identity. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Generated compliant resource name. |
<!-- END_TF_DOCS -->