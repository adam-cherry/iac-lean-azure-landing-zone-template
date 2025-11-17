# base-platform-iac

Infrastructure-as-Code (IaC) for the **acompany Base Platform**.
This repository manages governance, management groups, subscriptions, RBAC, networking, and shared services for the **app1 application** and future workloads.

👉 For application-level architecture and usage, please refer to the official [app1 Documentation](https://internal.example.com) (*internal link*).

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


## 🔒 Quality Assurance 

In alignment with our internal framework for quality management, our QA strategy ensures that every Terraform change is **measured, controlled and continuously improved** through standardized, automated gates, consistent naming and tagging, built-in diagnostics, and security-by-default templates.


* **Pre-Commit** → enforce formatting (`fmt`), linting (`tflint`), security scan (`tfsec`), and autogenerated docs (`terraform-docs`)
* **Build (CI)** → validate naming & diagnostics via helper modules, enforce tagging, security defaults, and AzAPI usage rules; run full validation, lint, and cost checks (`infracost`)
* **Release (CD)** → deploy only reviewed and approved plans (HITL); use federated credentials, isolated backends, and remote state locking; verify module outputs post-apply
* **Module Quality** → all modules must be idempotent, include centralized diagnostics, CAF naming, tagging defaults, and least-privilege security settings
* **Governance Enforcement** → private endpoints, managed identities, and diagnostics baked into wrappers; no local state or plaintext secrets in pipelines


---

### Tags
All resources must include default tags defined in `resource_tags_default`

Example:  
```hcl
resource_tags_default = {
  company = "acompany"
  project              = "aproject"
  created-by           = "Terraform"
  managed-by-terraform = "true"
}
````

---

### Resource Naming Convention

Consistent naming and tagging are essential for governance, automation, and cost management.  


We follow the [Azure Resource Naming Guidelines](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations) (CAF).

