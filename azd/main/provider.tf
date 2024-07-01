terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
      version = "2.52.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azuread" {
  tenant_id = "f1bed7c3-0dbe-4ea8-8a00-8915ab8eaaf8"
}

provider "azurerm" {
  features {}
}