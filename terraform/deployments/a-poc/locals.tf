locals {
  name_prefix = local.root_id
  tags        = merge({ env = local.environment }, local.resource_tags_default)
}