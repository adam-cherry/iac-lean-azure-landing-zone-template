# base-platform-iac

Infrastructure-as-Code (IaC) for the **Wattfox Core Platform** (Governance, Management Groups, Subscriptions, RBAC).

---

## 📦 Initial Template Deployment

The initial setup (Storage Account, Key Vault, Service Principal) is executed via a bootstrap script:

```bash
chmod +x ../../../devops/templates/terraform-setup.bash
../../../devops/templates/terraform-setup.bash
````

This script creates:

* Remote State Backend (Azure Storage Container)
* Bootstrap Key Vault for secrets
* Service Principal for Terraform pipelines

---

## 🚀 Terraform Deployment

### Prerequisites

* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
* [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)
* Access to the target subscription with **Owner** or **Contributor** role
* Pre-Commit CLI: brew install pre-commit
   * tflint: brew install tflint 
   * tfsec: brew install tfsec
   * terraform-doc: brew install terraform-docs


### Steps

1. **Login to Azure**

   ```bash
   az login
   az account set --subscription 7fa6baf1-0b1d-4f15-bcb7-f1b02e72eb76
   ```

2. **Initialize Terraform**

   ```bash
   terraform init
   ```

3. **Plan the Deployment**

   ```bash
   terraform plan

   # or

   terraform plan -out plan.tfplan
   ```

4. **Apply the Deployment**

   ```bash
   terraform apply

   # or

   terraform apply plan.tfplan
   ```

---

## 🔑 Notes

* Remote state is stored in the `corebackendsa` Storage Account (`tf-state-level1` container).
* Secrets (e.g. Service Principal credentials) are managed in the bootstrap Key Vault.
* Management Group hierarchy (`a-base`, `a-platform`, `wf-workloads`, `wf-decommissioned`) and subscription assignments are defined in `terraform.tfvars`.
* Subscription display names must currently be managed **outside Terraform** (e.g. via `az account subscription rename`).

---

```

### Explanation

* **root_id** → Prefix used for core resources (`a-base`, `a-platform`, etc.)
* **tenant_id** → Entra ID tenant for the environment
* **subscription_id** → Subscription used by Terraform to run deployments (often the management sub)
* **location** → Primary Azure region for core resources
* **resource_tags_default** → Tags applied to all resources (e.g. cost-center, project)

---

