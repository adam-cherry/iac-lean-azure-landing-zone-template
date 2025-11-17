locals {
  location = var.location

  #Example Output "shared_AllowHttpsOut" = { nsg_key = "shared", rule = {...} }
  nsg_rules_flat = flatten([
    for nsg_key, nsg in var.nsgs : [
      for rule in lookup(nsg, "security_rules", []) : {
        key     = "${nsg_key}_${rule.name}"
        nsg_key = nsg_key
        rule    = rule
      }
    ]
  ])
}
