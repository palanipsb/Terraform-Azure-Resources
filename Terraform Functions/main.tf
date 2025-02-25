locals {
  formated_name   = lower(replace(var.project_name, " ", "-"))
  tags_updated    = merge(var.default_tags, var.environment_tags)
  storageacc_name = substr(lower(replace(var.storageaccountname, " ", "")), 0, 23)
  nsg_rules = [for port in split(var.allowed_ports, ",") : {
    "port-${port}" = {
      priority               = port
      destination_port_range = "${port}"
      description            = "Allow HTTP ${port}"
    }

  }]
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.formated_name}"
  location = "West Europe"
  tags     = local.tags_updated
}

resource "azurerm_storage_account" "example" {
  name                     = local.storageacc_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.tags_updated
}

resource "azurerm_network_security_group" "nsg-example" {
  name                = "nsg-${local.formated_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

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
}
