resource "azurerm_storage_account" "asa-poc" {
  name                     = replace("stg-acc-${var.prefix}","-","")
  resource_group_name      = azurerm_resource_group.rg-training-poc.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "asp-poc" {
  name                     = "aps-${var.prefix}"
  resource_group_name      = azurerm_resource_group.rg-training-poc.name
  location                 = var.location
  os_type                  = "Linux"
  sku_name                 = "B1"
}

resource "azurerm_linux_function_app" "example" {
  name                = "lfa-${var.prefix}"
  resource_group_name      = azurerm_resource_group.rg-training-poc.name
  location                 = var.location

  storage_account_name       = azurerm_storage_account.asa-poc.name
  storage_account_access_key = azurerm_storage_account.asa-poc.primary_access_key
  service_plan_id            = azurerm_service_plan.asp-poc.id

  site_config {
    application_stack {
      node_version = 18
    }
  }
}