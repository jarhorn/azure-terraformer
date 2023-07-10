output "monitor_resource_group" {
  value     = azurerm_resource_group.rg
  sensitive = true
}

output "monitor_storage_account" {
  value     = azurerm_storage_account.st
  sensitive = true
}

output "monitor_log_analytics_workspace" {
  value     = azurerm_log_analytics_workspace.law
  sensitive = true
}
