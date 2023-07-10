locals {
  bastion_subnet_name = "AzureBastionSubnet" // magic string
}

resource "azurerm_public_ip" "bastion_ip" {
  allocation_method   = "Static"
  sku                 = "Standard"
  location            = var.location
  name                = "pip-bastion-${random_pet.pet.id}"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_bastion_host" "bastion" {
  location            = var.location
  name                = "bast-${random_pet.pet.id}"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "bastion_config"
    subnet_id            = azurerm_subnet.snet_bastion.id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
}
