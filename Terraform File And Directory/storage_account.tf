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
    environment = var.environment
  }
}
