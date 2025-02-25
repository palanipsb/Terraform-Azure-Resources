output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "tag_name" {
  value = azurerm_resource_group.rg.tags

}

output "storage_name" {
  value = azurerm_storage_account.example.name

}

output "security_rules" {
  value = azurerm_network_security_group.nsg-example.name
}
