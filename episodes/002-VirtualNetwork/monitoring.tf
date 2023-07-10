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

resource "azurerm_monitor_diagnostic_setting" "monitor_vnet" {
  name                       = "diag-vnet-${random_pet.pet.id}"
  target_resource_id         = azurerm_virtual_network.vnet.id
  log_analytics_workspace_id = local.monitor_log_analytics_workspace.id
  storage_account_id         = local.monitor_storage_account.id

  log {
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

resource "azurerm_monitor_diagnostic_setting" "monitor_nsg" {
  name                       = "diag-nsg-${random_pet.pet.id}"
  target_resource_id         = azurerm_network_security_group.nsg.id
  log_analytics_workspace_id = local.monitor_log_analytics_workspace.id
  storage_account_id         = local.monitor_storage_account.id

  log {
    category_group = "allLogs"

    retention_policy {
      enabled = false
    }
  }
}
