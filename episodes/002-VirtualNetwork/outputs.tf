output "network_resource_group" {
  value     = azurerm_resource_group.rg
  sensitive = true
}

output "network_virtual_network" {
  value     = azurerm_virtual_network.vnet
  sensitive = true
}

output "network_subnet" {
  value     = azurerm_subnet.snet
  sensitive = true
}
