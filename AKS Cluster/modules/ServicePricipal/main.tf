data "azuread_client_config" "current" {
  
}

resource "azuread_application" "app" {
  display_name = var.service_principal_name
  owners = [ data.azuread_client_config.current.object_id ]
}

resource "azuread_service_principal" "sp-main" {
  app_role_assignment_required = true
  client_id = azuread_application.app.client_id
  owners = [ data.azuread_client_config.current.object_id ]
}

resource "azuread_service_principal_password" "ap-pass" {
  service_principal_id = azuread_service_principal.sp-main.id
}