locals {
  # Global Context
  root_id             = "platform"
  tenant_id           = "XXXXXXXXXXXXXXXXXXX" # replace with your tenant ID
  subscription_id_iac = "XXXXXXXXXXXXXXXXXXX" # replace with your IaC subscription ID
  environment         = "prd"
  location            = "germanywestcentral"

  # Standard Tags
  resource_tags_default = {
    company              = "acompany"
    created-by           = "Adam Kirschstein"
    managed-by-terraform = "true"
    project              = "aproject"
  }

  # Backend Network Access Controls
  backend_ip_rules = [
    "0.0.0.0" # Local Dev IP
  ]

  # tflint-ignore: terraform_unused_declarations
  backend_subnet_ids = [] # Optional subnet allowlist for backend access

  # Required Resource Providers to register in IaC subscription
  resource_providers = [
    # --- Governance & Policy (minimal) ---
    "Microsoft.Management",

    # --- Networking & Connectivity ---
    "Microsoft.Network",

    # --- Monitoring & Logging ---
    "Microsoft.OperationalInsights",
    "Microsoft.Monitor",
    "microsoft.insights",

    # --- Security / Secrets / Storage ---
    # "Microsoft.KeyVault", already registered in bootstrap
    "Microsoft.Storage"

    # --- IAM / Access Management ---
    # "Microsoft.Authorization", already present by default
  ]
}