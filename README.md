# 🔓 iac-lean-azure-landing-zone

**A Lean, Open-Source Azure Landing Zone Framework** – A lightweight alternative to the Azure Verified Modules (AVM) Landing Zone.

This is an **Infrastructure-as-Code (IaC)** framework for building secure, scalable Azure landing zones with **governance, management groups, subscriptions, RBAC, networking, and shared services**.

## 🎯 What Makes This Different?

Unlike the complex standard **Azure Verified Modules (AVM) Landing Zone**, this project provides:

✅ **Lightweight & Modular** – Easy to understand, customize, and extend
✅ **Open-Source** – Full transparency, community-driven, and MIT-licensed
✅ **Flexible** – Drop in your own Root/Sub/Tenant IDs with minimal configuration
✅ **Composable Modules** – Three-tier strategy (helpers → wrappers → compositions)
✅ **Security-by-Default** – Private endpoints, managed identities, and diagnostics baked in
✅ **Production-Ready** – CI/CD pipelines, state management, and quality gates included

👉 For application-level architecture and usage, please refer to the official [app1 Documentation](https://internal.example.com) (*internal link*).

---

## 🛣️ Project Roadmap & Status

This project is **actively under development**. Here's what's planned:

### ✅ Current (MVP)
- [x] Bootstrap & state management
- [x] Governance layer (management groups, RBAC)
- [x] Management services (monitoring, Microsoft Defender)
- [x] Hub networking (VNets, private DNS, firewall, App Gateway WAF)
- [x] PoC workloads layer
- [x] Helper modules (naming, diagnostics)
- [x] Wrapper modules (Key Vault, Storage, Service Principal, Container Apps)
- [x] CI/CD pipelines (GitHub Actions)

### 🔄 In Progress
- 🚧 **Hub & Spoke Architecture** – Advanced multi-spoke networking patterns
- 🚧 **Demo Application Landing Zone** – Complete reference workload with:
  - Container Apps deployment
  - PostgreSQL/Azure Database
  - API Management
  - Observability stack (Prometheus, Grafana, Loki)
  - Private networking patterns

### 📋 Planned
- [ ] Composition modules for complete landing zone stacks
- [ ] Advanced security modules (Azure Sentinel, Azure Firewall policies)
- [ ] Cost optimization dashboards
- [ ] Multi-region deployment patterns
- [ ] Disaster recovery & failover automation
- [ ] Enhanced documentation & video tutorials

**See the Target Infrastructure Architecture:** [Target_Infrastructure.drawio](./docs/Target_Infrastructure.drawio) ([PNG Preview](./docs/Target_Infrastructure.drawio.png))

---

## 📖 Repository Documentation

| Location                                  | Description                                                                 |
|-------------------------------------------|-----------------------------------------------------------------------------|
| `terraform/deployments/*/README.md`   | Auto-generated Terraform Docs + Additional Usage Informations                          |

---

## 📂 Project Structure

| Path                              | Description                                                                 |
|----------------------------------|-----------------------------------------------------------------------------|
| `LICENSE`                        | License information for this repository                                      |
| `README.md`                      | Main repository documentation (this file)                                   |
| `devops/external/`               | External CLI helper scripts (e.g. subscription rename)                       |
| `devops/templates/`              | Terraform Setup Template scripts                    |
| `docs/`                          | Storage Documentation files & images                     |
| `terraform/deployments/a-bootstrap/` | Bootstrap deployment (remote state, key vault, service principal)          |
| `terraform/deployments/a-platform-gov/` | Governance layer (management groups, subscription associations, RBAC)     |
| `terraform/deployments/a-platform-mgmt/` | Management services (monitoring, defender, cost dashboards)               |
| `terraform/deployments/a-platform-hub/`  | Networking hub (VNets, private DNS, firewall, AppGW WAF)                  |
| `terraform/deployments/a-poc/`          | Proof-of-concept deployments for workloads (apps, observability, network) |
| `terraform/modules/`              | Reusable Terraform modules (shared across deployments)                      |

---

Module Strategy Description:

---

## ⚙️ Terraform Module Structure

The acompany IaC repository follows a **three-tier module strategy** for clarity, reusability, and security-by-default:

### 🧩 1. **Helper Modules** (`/modules/helpers`)

Foundational building blocks used across all wrappers and compositions.
Provide consistent naming, diagnostics, and shared logic.

* **a-naming** → Enforces CAF-aligned naming conventions
* **a-diagnostics** → Standardized resource logging and diagnostics configuration

---

### 🧱 2. **Wrapper Modules** (`/modules/wrappers`)

Secure, opinionated abstractions of individual Azure resources.
Each wrapper applies defaults for security, private access, and tagging.

Examples:

* `az-container-apps` – Container Apps instance
* `az-container-env` – Container Apps Environment
* `az-keyvault` – Key Vault with access policies
* `az-service-principal` – Federated identity for pipelines
* `az-storage-account` – Encrypted storage with private access
* `az-virtual-network` – Network including subnets and diagnostics

---

### 🧮 3. **Composition Modules** (`/modules/compositions`)

(Reserved for higher-level environment stacks)
Combine multiple wrappers and helpers into complete landing zones or workloads (e.g. app1, app2, or Hub).

---

**Design Principles:**

* Idempotent and composable modules
* Security-by-default (private endpoints, managed identities, diagnostics)
* Minimal variable exposure; defaults enforce platform standards
* Reusable across environments (Gov, Bootstrap, PoC, Spokes)

---

## 🚀 CI/CD

Terraform deployments are executed via **GitHub Actions**.  
Workflows will be stored in `.github/workflows/` (to be added).

The process is structured in three layers:

1. **Pre-Commit Hooks** → fast local checks before code is pushed  
2. **Build (GitHub Actions CI)** → centralized validation on pull requests  
3. **Release (GitHub Actions CD)** → controlled deployments to Azure with approval  

---

### 📝 Pre-Commit Hooks (Local Developer Workflow)

Configured in `.pre-commit-config.yaml`.  
Ensures that developers only push clean, validated code.

Typical hooks:

**Formatting**
  ```yaml
  - id: terraform_fmt
```

- Runs `terraform fmt` and enforces consistent formatting.

**Linting**

  ```yaml
  - id: terraform_tflint
  ```

- Runs `tflint` locally to catch syntax issues and best-practice violations.

**Security Scan**

  ```yaml
  - id: terraform_tfsec
  ```

  - Runs `tfsec` to detect security issues before commit.

**Auto-Documentation**

  ```yaml
  - repo: https://github.com/terraform-docs/terraform-docs
    rev: "v0.17.0"
    hooks:
      - id: terraform-docs-go
        args: ["markdown", "table", "--output-file", "README.md", "./"]
  ```

  - Auto-generates Terraform module documentation in `README.md`.

---

### ⚙️ Build Workflow (GitHub Actions CI)

Triggered on pull requests.
Provides centralized validation, security, and cost checks.

Steps:

* **Check formatting** → `terraform fmt -check`
* **Lint** → `tflint`
* **Security scan** → `tfsec .`
* **Docs check** → ensure `terraform-docs` output is up to date
* **Cost estimation** → `infracost breakdown` / `infracost diff`
* **Plan** → `terraform plan`, publish output as PR comment

---

### 🚀 Release Workflow (GitHub Actions CD)

Triggered on merge to `main` or release tags.
Executes the actual deployment to Azure.

Steps:

* **Init** → `terraform init`
* **Plan** → run again for safety
* **Apply** → `terraform apply` (requires manual approval via GitHub Environments)

---

### ✅ Summary

* **Pre-Commit** → local fast feedback
* **Build (CI)** → enforce standards and visibility in pull requests
* **Release (CD)** → safe, approved deployments to production



---


## 🚀 Quick Start

### Prerequisites

Before you can deploy this IaC, ensure you have the following tools installed:

```bash
# Azure CLI
brew install azure-cli  # or download from https://aka.ms/azurecli

# Terraform (v1.13.3+)
brew install terraform

# Pre-Commit Framework
brew install pre-commit

# Linting & Security Tools
brew install tflint
brew install tfsec

# Documentation Generator
brew install terraform-docs
```

### Local Setup & Development

```bash
# 1. Clone the repository
git clone <repository-url>
cd iac-lean-azure-landing-zone

# 2. Install pre-commit hooks locally
pre-commit install

# 3. Login to Azure
az login
az account set --subscription <subscription-id>

# 4. Navigate to a deployment
cd terraform/deployments/a-bootstrap

# 5. Initialize Terraform (fetches modules, configures backend)
terraform init

# 6. Run pre-commit checks locally (recommended before pushing)
pre-commit run --all-files
```

### Using Your Own Root/Tenant/Subscription IDs

One of the key benefits of this framework is **flexibility**. To adapt it to your own Azure hierarchy:

1. **Update your management group structure:**
   ```hcl
   # In terraform/deployments/a-platform-gov/terraform.tfvars
   management_groups = {
     root = {
       display_name = "YOUR-ROOT-MG"
       parent_id    = "YOUR-TENANT-ID"
     }
     platform = {
       display_name = "YOUR-PLATFORM-MG"
       parent_id    = "YOUR-ROOT-MG-ID"
     }
   }
   ```

2. **Set your subscription IDs:**
   ```hcl
   # In terraform/deployments/<your-deployment>/terraform.tfvars
   subscription_id = "YOUR-SUBSCRIPTION-ID"
   ```

3. **Customize naming conventions:**
   ```hcl
   # In terraform/modules/helpers/a-naming/variables.tf
   environment = "prod"      # Change to your environment
   company     = "yourcompany"  # Change to your organization
   ```

4. **Extend with your own modules:**
   - Create new wrapper modules in `terraform/modules/wrappers/`
   - Create composition modules in `terraform/modules/compositions/`
   - Reference them in your deployments as needed

That's it! The framework is designed to be adaptable with minimal configuration changes.

### Common Terraform Commands

```bash
# Format and validate Terraform code
terraform fmt -recursive

# Validate syntax
terraform validate

# Plan changes (dry-run)
terraform plan
terraform plan -out plan.tfplan

# Apply changes
terraform apply
terraform apply plan.tfplan

# Destroy resources (use with caution!)
terraform destroy
```

### Bootstrap a New Deployment

To deploy a new environment, you must first bootstrap the remote state backend:

```bash
cd terraform/deployments/<deployment-name>
chmod +x ../../../devops/templates/terraform-setup.bash
../../../devops/templates/terraform-setup.bash
```

This script will create:
- Azure Storage Account for remote state
- Key Vault for secrets
- Service Principal for CI/CD pipeline automation

---

## 🔒 Quality Assurance

In alignment with our internal framework for quality management, our QA strategy ensures that every Terraform change is **measured, controlled and continuously improved** through standardized, automated gates, consistent naming and tagging, built-in diagnostics, and security-by-default templates.

### Quality Gates

* **Pre-Commit** → enforce formatting (`fmt`), linting (`tflint`), security scan (`tfsec`), and autogenerated docs (`terraform-docs`)
* **Build (CI)** → validate naming & diagnostics via helper modules, enforce tagging, security defaults, and AzAPI usage rules; run full validation, lint, and cost checks (`infracost`)
* **Release (CD)** → deploy only reviewed and approved plans (HITL); use federated credentials, isolated backends, and remote state locking; verify module outputs post-apply
* **Module Quality** → all modules must be idempotent, include centralized diagnostics, CAF naming, tagging defaults, and least-privilege security settings
* **Governance Enforcement** → private endpoints, managed identities, and diagnostics baked into wrappers; no local state or plaintext secrets in pipelines

---

## 📋 Key Patterns & Conventions

### Resource Tagging

All resources must include default tags defined in `resource_tags_default`:

```hcl
resource_tags_default = {
  company              = "acompany"
  project              = "aproject"
  created-by           = "Terraform"
  managed-by-terraform = "true"
}
```

### Resource Naming Convention

Consistent naming and tagging are essential for governance, automation, and cost management.

We follow the [Azure Resource Naming Guidelines](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations) (CAF).

Use the `a-naming` helper module to generate compliant resource names:

```hcl
module "naming" {
  source = "../../modules/helpers/a-naming"

  environment = "prod"
  location    = "westeurope"
}

resource "azurerm_resource_group" "example" {
  name = module.naming.resource_group.name
}
```

### Centralized Diagnostics

All deployable resources must integrate with the `a-diagnostics` helper module for centralized logging:

```hcl
module "diagnostics" {
  source = "../../modules/helpers/a-diagnostics"

  log_analytics_workspace_id = azurerm_log_analytics_workspace.base.id
  storage_account_id         = azurerm_storage_account.diag.id
}
```

---

## 💾 State Management

- **Remote State:** Stored in `abasebackendsa` Storage Account (`tf-state-level1` container)
- **State Locking:** Prevents concurrent modifications
- **Secrets:** Managed in bootstrap Key Vault; **DO NOT commit `.tfvars` containing plaintext secrets**
- **Bootstrap:** Run `terraform-setup.bash` before any deployment to create remote state backend

---

## 📚 Additional Documentation

- **CLAUDE.md** – Extended developer guidance for working with this repository
- **Deployment READMEs** – Each deployment (`terraform/deployments/*/README.md`) includes auto-generated Terraform documentation
- **Quality Framework** – [Internal Quality Management](https://internal.example.com) documentation (*internal link*)

---

## ⚠️ Important Notes

- **No Local State:** Never commit `.terraform/` or local state files to version control
- **Subscription Names:** Currently managed outside Terraform via `az account subscription rename`
- **Management Group Hierarchy:** Defined in `terraform.tfvars` as `a-base`, `a-platform`, `a-workloads`, `a-decommissioned`
- **Federated Credentials:** Service principals use federated identities (OIDC) with GitHub Actions—no secrets stored in Azure DevOps

---

## 🤝 Contributing & Community

This is an **open-source project**, and we welcome contributions from the community!

### How to Contribute

1. **Fork** this repository
2. **Create a feature branch** (`git checkout -b feature/my-awesome-feature`)
3. **Make your changes** and ensure pre-commit hooks pass
4. **Write clear commit messages** following conventional commits
5. **Submit a pull request** with a detailed description

### Contribution Guidelines

- Follow the [CLAUDE.md](./CLAUDE.md) project conventions
- Ensure all modules are **idempotent** and include **diagnostics**
- Add CAF-compliant naming and tagging
- Include tests and documentation for new features
- All changes require peer review before merging to `main`

### Code of Conduct

Be respectful, inclusive, and collaborative. We're building this together! 🚀

---

## 📄 License

This project is licensed under the **MIT License** – see [LICENSE](./LICENSE) for details.

**Open Source, Open Minded, Open to Contributions!**

---

## 📞 Support & Feedback

For questions, issues, or feedback related to this IaC repository:

- **Internal Documentation:** Refer to the [app1 Documentation](https://internal.example.com) and [Quality Framework](https://internal.example.com)
- **GitHub Issues:** Create an issue in this repository for bug reports and feature requests
- **Discussions:** Start a GitHub Discussion for architectural questions and ideas
- **Code Review:** All changes require peer review via pull request before merging to `main`

---

## 🙏 Acknowledgments

Built with best practices from:
- [Azure Cloud Adoption Framework (CAF)](https://learn.microsoft.com/azure/cloud-adoption-framework/)
- [Azure Verified Modules (AVM)](https://github.com/Azure/terraform-azurerm-avm)
- Community feedback and real-world deployments

