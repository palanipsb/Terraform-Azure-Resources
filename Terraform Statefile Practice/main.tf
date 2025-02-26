
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.19.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate-day04"         # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "day0421935"            # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"               # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "dev.terraform.tfstate" # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
  required_version = ">=1.9.0"
}

provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "rg_poc_training" {
  name     = "rg_poc_training"
  location = "southeastasia"
}

resource "azurerm_virtual_network" "vnet-poc-training" {
  name                = "vnet-poc-training"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_poc_training.location
  resource_group_name = azurerm_resource_group.rg_poc_training.name
}

resource "azurerm_subnet" "subnet-poc-training" {
  name                 = "subnet-poc-training"
  resource_group_name  = azurerm_resource_group.rg_poc_training.name
  virtual_network_name = azurerm_virtual_network.vnet-poc-training.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
}

resource "azurerm_storage_account" "storageaccountpoc001" {
  name                = "sapalanipsb001"
  resource_group_name = azurerm_resource_group.rg_poc_training.name

  location                 = azurerm_resource_group.rg_poc_training.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["100.0.0.1"]
    virtual_network_subnet_ids = [azurerm_subnet.subnet-poc-training.id]
  }

  tags = {
    environment = "staging"
  }
}
