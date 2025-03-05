terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-poc"
    storage_account_name = "sapalanipsb001"
    container_name       = "vhds-terraform-poc" 
    key                  = "dev.terraform.tfstate" 
  }
}
