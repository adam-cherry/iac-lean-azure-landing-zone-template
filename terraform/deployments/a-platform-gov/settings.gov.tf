locals {
  # Global context
  location        = "germanywestcentral"
  tenant_id       = "XXXXXXXXXXXXXXXXXX" # replace with your tenant ID
  subscription_id = "XXXXXXXXXXXXXXXXXX" # replace with your subscription ID

  # Standard Tags
  # tflint-ignore: terraform_unused_declarations
  resource_tags_default = {
    company              = "acompany"
    created-by           = "Adam Kirschstein"
    managed-by-terraform = "true"
    project              = "aproject"
  }

  # Management Group Hierarchy
  mgmt_groups = {
    root = "a-base"

    level1 = {
      platform       = "a-platform"
      workloads      = "a-workloads"
      decommissioned = "a-decommissioned"
    }

    level2 = {
      workloads = {
        app1 = "app1"
        app2 = "app2"
      }
    }
  }

  # Subscription Mapping
  subscriptions = {
    management = {
      id        = "/subscriptions/25811a6b-1d01-432f-b839-5a365e0cff45"
      mg_parent = "platform"
    }
    hub = {
      id        = "/subscriptions/5ecbf72c-aad1-42ce-bccc-caabc9a4751e"
      mg_parent = "platform"
    }
    app1-prd = {
      id        = "/subscriptions/7fa6baf1-0b1d-4f15-bcb7-f1b02e72eb76"
      mg_parent = "workloads-app1"
    }
  }
}
