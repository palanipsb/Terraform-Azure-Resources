resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnet1-name
  resource_group_name = var.resource_name
  location            = var.location
  address_space       = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "vnet1-subnet-1" {
  name                 = var.vnet1_subnet1_name
  resource_group_name  = azurerm_resource_group.rg-training-poc.name
  virtual_network_name = var.vnet1-name
  address_prefixes     = ["10.0.1.0/26"]
}

resource "azurerm_virtual_network" "vnet2" {
  name                = var.vnet2-name
  resource_group_name = azurerm_resource_group.rg-training-poc.name
  location            = var.location
  address_space       = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "vnet2-subnet-1" {
  name                 = var.vnet2_subnet1_name
  resource_group_name  = var.resource_name
  virtual_network_name = var.vnet2-name
  address_prefixes     = ["10.0.2.0/26"]
}

resource "azurerm_virtual_network_peering" "vnet-peering-1" {
  name                      = var.vnet-peering-1
  resource_group_name       = var.resource_name
  virtual_network_name      = var.vnet1-name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
}

resource "azurerm_virtual_network_peering" "vnet-peering-2" {
  name                      = var.vnet-peering-2
  resource_group_name       = var.resource_name
  virtual_network_name      = var.vnet2-name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
}

