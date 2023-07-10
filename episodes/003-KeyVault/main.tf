resource "random_pet" "pet" {}

data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "rg-${random_pet.pet.id}"
}

resource "azurerm_key_vault" "kv" {
  location                 = var.location
  name                     = "kv-${random_pet.pet.id}"
  resource_group_name      = azurerm_resource_group.rg.name
  sku_name                 = "standard"
  tenant_id                = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = false
}

resource "azurerm_key_vault_access_policy" "kvap" {
  key_vault_id = azurerm_key_vault.kv.id
  object_id    = data.azurerm_client_config.current.object_id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  key_permissions = [
    "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import",
    "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update",
    "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy",
    "SetRotationPolicy"
  ]
  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore",
    "Set"
  ]
  certificate_permissions = [
    "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers",
    "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers",
    "Purge", "Recover", "Restore", "SetIssuers", "Update"
  ]
  storage_permissions = [
    "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS",
    "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"
  ]
}

resource "azurerm_key_vault_secret" "ssh_key_private" {
  key_vault_id = azurerm_key_vault.kv.id
  name         = "ssh-private"
  value        = tls_private_key.ssh_key.private_key_pem
}

resource "azurerm_key_vault_secret" "ssh_key_public" {
  key_vault_id = azurerm_key_vault.kv.id
  name         = "ssh-public"
  value        = tls_private_key.ssh_key.public_key_openssh
}
