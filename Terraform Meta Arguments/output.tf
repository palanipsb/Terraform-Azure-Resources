output "storage_account_names" {
  description = "Names of the created storage accounts"
  value       = [for sa in azurerm_storage_account.storageaccountcount : sa.name]
}

output "resource_group_names" {
  description = "Names of the resource groups"
  value       = [for rg in azurerm_resource_group.rg_poc_training : rg.name]
}
