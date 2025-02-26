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
<<<<<<< HEAD
  value = azurerm_network_security_group.nsg-example.security_rule.*
}

output "vm_size" {
  value = local.vm_size

}

output "backup" {
  value = var.backup_name

}

output "credential" {
  value     = var.credential
  sensitive = true

}

output "unique_location" {
  value = local.unique_location
}

output "possitive_cost" {
  value = local.possitive_cost
}

output "max_cost" {
  value = local.max_cost

}

output "resource_tag" {
  value = local.resource_name_tagged
}

output "formated_tag_date" {
  value = local.tag_date
=======
  value = azurerm_network_security_group.nsg-example.name
>>>>>>> b4470fabf335b3d76c0995052ef16f0c22b21487
}
