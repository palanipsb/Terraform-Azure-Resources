resource "azurerm_virtual_network" "main" {
  name                = "${var.environment}-network"
  address_space       = ["${element(var.network_config, 0)}"]
  location            = azurerm_resource_group.rg_poc_training.location
  resource_group_name = azurerm_resource_group.rg_poc_training.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg_poc_training.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["${element(var.network_config, 1)}/${element(var.network_config, 2)}"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.environment}-nic"
  location            = azurerm_resource_group.rg_poc_training.location
  resource_group_name = azurerm_resource_group.rg_poc_training.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.environment}-vm"
  location              = azurerm_resource_group.rg_poc_training.location
  resource_group_name   = azurerm_resource_group.rg_poc_training.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.allowed_vm_sizes[0]

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = var.delete_os_disk_on_termination

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = var.delete_data_disks_on_termination

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
    disk_size_gb      = var.disksize
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = var.resource_tags
}
