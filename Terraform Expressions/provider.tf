terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.19.0"
    }
  }
  required_version = ">=1.9.0"
}

provider "azurerm" {
  features {
  }
  subscription_id = "133a00b8-22ea-409d-900a-f84ccff97893"
}
