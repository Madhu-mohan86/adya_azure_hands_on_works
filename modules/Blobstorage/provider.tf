terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    random={
        source = "hashicorp/random"
    }
  }
}

provider "azurerm" {
skip_provider_registration = true
  features {}
}

