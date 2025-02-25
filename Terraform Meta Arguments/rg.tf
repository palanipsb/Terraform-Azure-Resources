resource "azurerm_resource_group" "rg_poc_training" {
  for_each = var.rg_config
  name     = "rg_${each.key}"
  location = each.value.location
  lifecycle {
    ignore_changes = [tags]
  }
}
