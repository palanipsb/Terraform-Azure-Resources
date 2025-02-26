resource "azurerm_storage_account" "storageaccountcount" {
  for_each                 = var.rg_config
  name                     = "${var.sa_name_prefix}${each.key}"
  resource_group_name      = "rg_${each.key}"
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.account_replication_type[0]
  tags                     = var.resource_tags
  lifecycle {
    prevent_destroy = false
    precondition {
      condition     = contains(var.allowed_location, var.location)
      error_message = "Please enter a valid location"
    }
  }
}
