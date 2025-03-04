resource "azurerm_storage_account" "storageaccountpoc001" {
  name                = "sapalanipsb001"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_poc_training.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "example" {
  name                  = "vhds-${var.prefix}"
  storage_account_id    = azurerm_storage_account.storageaccountpoc001.id
  container_access_type = "private"
}