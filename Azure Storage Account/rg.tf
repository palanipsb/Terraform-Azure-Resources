resource "azurerm_resource_group" "rg_poc_training" {
  name     = "rg-${var.prefix}"
  location = var.location
}