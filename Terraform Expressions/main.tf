resource "azurerm_network_security_group" "nsg-example" {
  name                = var.environment == "dev" ? "dev-nsg" : "stage:nsg"
  location            = var.location
  resource_group_name = var.azurerm_resource_group

  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = security_rule.value.description
    }

  }

  tags = var.environment
}
