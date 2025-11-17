locals {
  # Build resource name depending on type
  name = (
    var.type == "standard" ?
    "${var.abbr}-${var.rootid}-${var.environment}${var.index != null && var.index != "" ? "-${var.index}" : ""}" :
    var.type == "extended" ?
    "${var.abbr}-${var.rootid}-${var.component}-${var.environment}${var.index != null && var.index != "" ? "-${var.index}" : ""}" :
    var.type == "compact" ?
    "${var.abbr}${var.rootid}${var.environment}${var.index != null ? var.index : ""}" :
    var.type == "compact_extended" ?
    "${var.abbr}${var.rootid}${var.component}${var.environment}${var.index != null ? var.index : ""}" :
    var.type == "identity" ?
    "${var.abbr}-${var.purpose}-${var.environment}${var.index != null && var.index != "" ? "-${var.index}" : ""}" :
    var.type == "connectivity" ?
    "${var.abbr}-${var.purpose}-${local.region_abbr}${var.index != null && var.index != "" ? "-${var.index}" : ""}" :
    ""
  )


  # --- Region Mapping (CAF short codes) ---
  region_map = {
    "germanywestcentral" = "gwc"
  }
  # --- Auto-Derived Region Abbreviation ---
  region_abbr = lookup(local.region_map, lower(var.location), "unk")
}
