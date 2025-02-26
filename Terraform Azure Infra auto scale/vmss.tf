resource "azurerm_orchestrated_virtual_machine_scale_set" "vmss-training-poc" {
  name                        = "vmss-terraform-poc"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  sku_name                    = "Standard_D2s_v4"
  instances                   = 3
  platform_fault_domain_count = 1
  zones                       = ["1"]

  user_data_base64 = base64encode(file("user-data.sh"))
  os_profile {
    linux_configuration {
      disable_password_authentication = true
      admin_username                  = "azureuser"
      admin_ssh_key {
        username   = "azureuser"
        public_key = file(".ssh/key.pub")
      }
    }
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name                          = "nic"
    primary                       = true
    enable_accelerated_networking = false

    ip_configuration {
      name                                   = "ipconfig"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet-training-poc.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bckendLB-traiining-poc.id]
    }
  }

  boot_diagnostics {
    storage_account_uri = ""
  }
  lifecycle {
    ignore_changes = [instances]
  }

}
