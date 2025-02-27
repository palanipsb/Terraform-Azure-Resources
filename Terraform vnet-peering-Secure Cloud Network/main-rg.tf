resource "azurerm_resource_group" "rg-training-poc" {
  name     = var.resource_name
  location = var.location
}
