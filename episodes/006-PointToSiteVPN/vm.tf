locals {
  ubuntu_22_04_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  ubuntu_20_04_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  location            = var.location
  name                = "vm-${random_pet.pet.id}"
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_DS2_v2"

  computer_name                   = "linuxvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true
  admin_ssh_key {
    username   = "azureuser"
    public_key = data.azurerm_key_vault_secret.ssh_public_key.value
  }

  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    name                 = "disk-${random_pet.pet.id}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = local.ubuntu_20_04_image_reference.publisher
    offer     = local.ubuntu_20_04_image_reference.offer
    sku       = local.ubuntu_20_04_image_reference.sku
    version   = local.ubuntu_20_04_image_reference.version
  }

  boot_diagnostics {
    storage_account_uri = local.monitor_storage_account.primary_blob_endpoint
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown" {
  daily_recurrence_time = "1800"
  location              = var.location
  timezone              = "Eastern Standard Time"
  virtual_machine_id    = azurerm_linux_virtual_machine.vm.id
  notification_settings {
    enabled         = true
    email           = "jason.horn@crowe.com"
    time_in_minutes = 45
  }
}
