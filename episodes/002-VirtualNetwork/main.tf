resource "random_pet" "pet" {}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "rg-${random_pet.pet.id}"
}

resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  name                = "vnet-${random_pet.pet.id}"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "snet" {
  address_prefixes     = ["10.0.0.0/24"]
  name                 = "snet-${random_pet.pet.id}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

