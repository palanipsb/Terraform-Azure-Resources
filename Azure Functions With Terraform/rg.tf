resource "azurerm_resource_group" "rg-training-poc" {
    name = "rg-${var.prefix}"
    location = var.location  
}

