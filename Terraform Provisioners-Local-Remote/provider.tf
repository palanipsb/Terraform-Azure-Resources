terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.21.1"
    }
  }
  required_version = ">=1.9.0"
}
provider "azurerm" {
  features {

  }
}
