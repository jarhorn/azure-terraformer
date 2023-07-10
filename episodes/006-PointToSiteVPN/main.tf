resource "random_pet" "pet" {}

data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "rg-${random_pet.pet.id}"
}
