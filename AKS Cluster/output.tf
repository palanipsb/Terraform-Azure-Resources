output "resource_group_name" {
  value = azurerm_resource_group.rg-training-poc.name
}

output "client_id" {
  description = "The application id of AzureAD application created."
  value       = module.ServicePrincipal.client_id
}

output "client_secret" {
  description = "Password for service principal."
  value       = module.ServicePrincipal.client_secret
  sensitive = true

}