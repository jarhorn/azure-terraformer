terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 0.6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
  }
}

provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/jarhorn"
  personal_access_token = file("../ado.pat")
}
