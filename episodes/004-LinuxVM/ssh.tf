data "terraform_remote_state" "ssh" {
  backend = "local"
  config = {
    path = var.ssh_state_path
  }
}

locals {
  ssh_remote_outputs = data.terraform_remote_state.ssh.outputs
  ssh_key_vault      = local.ssh_remote_outputs.key_vault
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  key_vault_id = local.ssh_key_vault.id
  name         = "ssh-public"
}
