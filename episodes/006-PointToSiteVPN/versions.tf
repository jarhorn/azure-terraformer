terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.41.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.4"
    }
  }
}

provider "azurerm" {
  features {}
}
