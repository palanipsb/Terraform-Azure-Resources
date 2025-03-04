terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "=3.0.0"
    }
  }
}

provider "azuread" {}