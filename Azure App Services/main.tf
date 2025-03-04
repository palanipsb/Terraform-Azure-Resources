resource "azurerm_app_service_plan" "asp-training-poc" {
  name                = "asp-${var.prefix}"
  location            = azurerm_resource_group.rg-training-poc.location
  resource_group_name = azurerm_resource_group.rg-training-poc.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "aas-training-poc" {
  name                = "aas-${var.prefix}"
  location            = azurerm_resource_group.rg-training-poc.location
  resource_group_name = azurerm_resource_group.rg-training-poc.name
  app_service_plan_id = azurerm_app_service_plan.asp-training-poc.id
}

resource "azurerm_app_service_slot" "slot" {
  name                = "staging-${var.prefix}"
  app_service_name    = azurerm_app_service.aas-training-poc.name
  location            = azurerm_resource_group.rg-training-poc.location
  resource_group_name = azurerm_resource_group.rg-training-poc.name
  app_service_plan_id = azurerm_app_service_plan.asp-training-poc.id
}

resource "azurerm_app_service_source_control" "aassc" {
  app_id   = azurerm_app_service.aas-training-poc.id
  repo_url = "https://github.com/palanipsb/awesome-terraform.git"
  branch   = "master"
}

resource "azurerm_app_service_source_control_slot" "aassc-slot" {
  slot_id  = azurerm_app_service_slot.slot.id
  repo_url = "https://github.com/palanipsb/awesome-terraform.git"
  branch   = "appServiceSlot_Working_DO_NOT_MERGE"
}

resource "azurerm_web_app_active_slot" "web-slot" {
  slot_id = azurerm_app_service_slot.slot.id
}