resource "azurerm_resource_group" "rg_poc_training" {
  for_each = var.rg_config
  name     = "rg_${each.key}"
  location = each.value.location
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags]
  }
}
