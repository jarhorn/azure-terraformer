resource "random_pet" "pet" {}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "rg-${random_pet.pet.id}"
}

resource "azurerm_storage_account" "st" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = var.location
  name                     = replace("st${random_pet.pet.id}", "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
}

resource "azurerm_log_analytics_workspace" "law" {
  location            = var.location
  name                = "law-${random_pet.pet.id}"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "activity_logs" {
  name                       = "diag-${random_pet.pet.id}"
  target_resource_id         = data.azurerm_subscription.current.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  storage_account_id         = azurerm_storage_account.st.id

  log {
    category = "Administrative"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "Security"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "ServiceHealth"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "Alert"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "Recommendation"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "Policy"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "Autoscale"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "ResourceHealth"

    retention_policy {
      enabled = false
    }
  }
}
