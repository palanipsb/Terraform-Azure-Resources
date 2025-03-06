resource "azurerm_resource_group" "rg-training-poc" {
    name = "rg-${var.prefix}"
    location = var.location[0]

    tags = {
      department = "IT"
      project = "training-poc"
    }
}

