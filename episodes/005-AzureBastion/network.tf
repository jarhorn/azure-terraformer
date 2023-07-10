data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = var.network_state_path
  }
}

locals {
  network_remote_outputs  = data.terraform_remote_state.network.outputs
  network_resource_group  = local.network_remote_outputs.network_resource_group
  network_virtual_network = local.network_remote_outputs.network_virtual_network
  network_subnet          = local.network_remote_outputs.network_subnet
}

data "azurerm_subnet" "snet" {
  name                 = local.network_subnet.name
  resource_group_name  = local.network_resource_group.name
  virtual_network_name = local.network_virtual_network.name
}

resource "azurerm_network_interface" "nic" {
  location            = var.location
  name                = "nic-private-${random_pet.pet.id}"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.snet.id
  }
}

resource "azurerm_subnet" "snet_bastion" {
  address_prefixes     = ["10.0.240.224/27"]
  name                 = local.bastion_subnet_name
  resource_group_name  = local.network_resource_group.name
  virtual_network_name = local.network_virtual_network.name
}
