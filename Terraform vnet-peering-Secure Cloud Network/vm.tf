resource "azurerm_network_interface" "main-nic-1" {
  name                = "nic-1-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.vnet1-subnet-1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm-1" {
  name                  = "vm-1-${var.prefix}"
  location              = var.location
  resource_group_name   = var.resource_name
  network_interface_ids = [azurerm_network_interface.main-nic-1.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

resource "azurerm_network_interface" "main-nic-2" {
  name                = "nic-2-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_name

  ip_configuration {
    name                          = "testconfiguration2"
    subnet_id                     = azurerm_subnet.vnet2-subnet-1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm-2" {
  name                  = "vm-2-${var.prefix}"
  location              = var.location
  resource_group_name   = var.resource_name
  network_interface_ids = [azurerm_network_interface.main-nic-2.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
