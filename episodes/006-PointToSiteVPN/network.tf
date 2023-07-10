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

resource "azurerm_subnet" "snet_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = local.network_resource_group.name
  virtual_network_name = local.network_virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pip_vpn" {
  allocation_method   = "Static"
  sku                 = "Standard"
  location            = var.location
  name                = "pip-vpn-${random_pet.pet.id}"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network_gateway" "vgw" {
  location            = var.location
  name                = "vgw-${random_pet.pet.id}"
  resource_group_name = local.network_resource_group.name
  sku                 = "VpnGw1"
  type                = "Vpn"
  vpn_type            = "RouteBased"

  active_active = false
  enable_bgp    = false


  ip_configuration {
    name                          = "vgw-config"
    public_ip_address_id          = azurerm_public_ip.pip_vpn.id
    subnet_id                     = azurerm_subnet.snet_gateway.id
    private_ip_address_allocation = "Dynamic"
  }

  vpn_client_configuration {
    address_space = ["172.16.0.0/24"]

    vpn_auth_types       = ["AAD"]
    vpn_client_protocols = ["OpenVPN"]

    aad_tenant   = "https://login.microsoftonline.com/${var.azuread_tenant_id}"
    aad_audience = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
    aad_issuer   = "https://sts.windows.net/${var.azuread_tenant_id}/"
  }
}
