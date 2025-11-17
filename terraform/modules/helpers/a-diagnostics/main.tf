resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "diag-${var.resource_name}"
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # Logs
  dynamic "enabled_log" {
    for_each = toset(local.categories)
    content {
      category = enabled_log.value
    }
  }

  # Metrics (new schema only)
  dynamic "enabled_metric" {
    for_each = var.metrics_enabled ? toset(["AllMetrics"]) : []
    content {
      category = enabled_metric.value
    }
  }

  # Azure often returns expanded metric categories (e.g., "Capacity", "Transaction") 
  # instead of "AllMetrics", which causes Terraform to detect a false drift and replan. 
  # Ignoring changes on 'enabled_metric' prevents unnecessary in-place updates.
  lifecycle {
    ignore_changes = [
      enabled_metric,
      log_analytics_destination_type
    ]
  }
}
