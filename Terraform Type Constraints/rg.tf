resource "azurerm_resource_group" "rg_poc_training" {
  name     = "rg_poc_training"
  location = var.allowed_location[0]
}
