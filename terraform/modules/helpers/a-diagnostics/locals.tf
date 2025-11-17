locals {
  # Default log categories per supported resource type
  log_categories = {
    firewall = [
      "AzureFirewallApplicationRule",
      "AzureFirewallNetworkRule",
      "AzureFirewallDnsProxy"
    ]

    container_environment = [
      "AppEnvSessionConsoleLogs",
      "AppEnvSessionLifeCycleLogs",
      "AppEnvSessionPoolEventLogs",
      "AppEnvSpringAppConsoleLogs",
      "ContainerAppConsoleLogs",
      "ContainerAppSystemLogs"
    ]

    public_ip = [
      "DDoSProtectionNotifications",
      "DDoSMitigationFlowLogs",
      "DDoSMitigationReports"
    ]

    application_gateway = [
      "ApplicationGatewayAccessLog",
      "ApplicationGatewayPerformanceLog",
      "ApplicationGatewayFirewallLog"
    ]

    load_balancer = [
      "LoadBalancerAlertEvent",
      "LoadBalancerProbeHealthStatus",
      "LoadBalancerRuleCounter"
    ]

    storage = ["StorageRead", "StorageWrite", "StorageDelete"]

    key_vault = [
      "AuditEvent"
    ]

    sql_server = [
      "SQLSecurityAuditEvents",
      "Errors"
    ]

    app_service = [
      "AppServiceHTTPLogs",
      "AppServiceConsoleLogs",
      "AppServiceAppLogs"
    ]

    container_app = [ #via container environment‚
    ]

    function_app = [
      "FunctionAppLogs"
    ]

    redis = [
      "ConnectedClientList",
      "RedisServerLoad"
    ]

    servicebus = [
      "OperationalLogs"
    ]

    eventhub = [
      "OperationalLogs"
    ]
    nsg = [
      "NetworkSecurityGroupEvent",
      "NetworkSecurityGroupRuleCounter"
    ]
  }

  # Use override if provided, else defaults for type
  categories = (
    length(var.categories_override) > 0
    ? var.categories_override
    : lookup(local.log_categories, var.resource_type, [])
  )
}
