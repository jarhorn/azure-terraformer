resource "azurerm_network_security_group" "nsg" {
  location            = var.location
  name                = "nsg-${random_pet.pet.id}"
  resource_group_name = azurerm_resource_group.rg.name
}

data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com"
}

resource "azurerm_network_security_rule" "rule" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "AllowSSHFromCroweVPN"
  network_security_group_name = azurerm_network_security_group.nsg.name
  priority                    = 100
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${chomp(data.http.my_ip.response_body)}/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "snet_nsg_assoc" {
  network_security_group_id = azurerm_network_security_group.nsg.id
  subnet_id                 = azurerm_subnet.snet.id
}
