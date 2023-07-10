data "terraform_remote_state" "monitor" {
  backend = "local"
  config = {
    path = var.monitoring_state_path
  }
}

locals {
  remote_outputs                  = data.terraform_remote_state.monitor.outputs
  monitor_resource_group          = local.remote_outputs.monitor_resource_group
  monitor_storage_account         = local.remote_outputs.monitor_storage_account
  monitor_log_analytics_workspace = local.remote_outputs.monitor_log_analytics_workspace
}

resource "azurerm_monitor_diagnostic_setting" "kv_diag" {
  name                       = "diag-${random_pet.pet.id}"
  target_resource_id         = azurerm_key_vault.kv.id
  log_analytics_workspace_id = local.monitor_log_analytics_workspace.id
  storage_account_id         = local.monitor_storage_account.id

  enabled_log {
    category_group = "audit"

    retention_policy {
      enabled = false
    }
  }
  enabled_log {
    category_group = "allLogs"

    retention_policy {
      enabled = false
    }
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}
