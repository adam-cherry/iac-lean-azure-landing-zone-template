output "location" {
  value = local.location
}

output "example_name" {
  value = module.naming.name
}

output "vnet_name" {
  value = module.vnet.vnet_name
}

output "subnet_ids" {
  value = module.vnet.subnet_ids
}
