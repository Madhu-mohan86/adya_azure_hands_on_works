terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  # Configuration options
  skip_provider_registration = true
  features {}
}