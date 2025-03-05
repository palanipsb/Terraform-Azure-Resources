resource "azurerm_virtual_network" "example" {
  name                = "vnet-${var.prefix}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-training-poc.name
}

resource "azurerm_subnet" "example" {
  name                 = "snet-${var.prefix}"
  resource_group_name = azurerm_resource_group.rg-training-poc.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "example" {
  name                = "nsg-${var.prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-training-poc.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "http"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "example" {
  name                = "PublicIp-${var.prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-training-poc.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "example" {
  name                = "nic-${var.prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-training-poc.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "null_resource" "pre_deployment_prep" {
    triggers = {
        always_run = timestamp()
    }
    provisioner "local-exec" {
      command = "echo 'Deplyment started at ${timestamp()}' > deployment-started-${timestamp()}.log"
    }
  
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "vm-${var.prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-training-poc.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  depends_on = [ null_resource.pre_deployment_prep ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      
      # Create a sample welcome page
      "echo '<html><body><h1>Terraform is Awesome!</h1></body></html>' | sudo tee /var/www/html/index.html",
      
      # Ensure nginx is running
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"  
      ]
      connection {
        type = "ssh"
        user = "azureuser"
        private_key = file("~/.ssh/id_rsa")
        host = azurerm_public_ip.example.ip_address
      }
  
    }
    provisioner "file" {
      connection {
        type = "ssh"
        user = "azureuser"
        private_key = file("~/.ssh/id_rsa")
        host = azurerm_public_ip.example
      }
      source = "config/sample.conf"
      destination = "/home/azureuser/sample.conf"
    }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "null_resource" "post_deployment_prep" {
    triggers = {
        always_run = timestamp()
    }
    provisioner "local-exec" {
      command = "echo 'Deplyment ended at ${timestamp()}' > deployment-ended-${timestamp()}.log"
    }
  depends_on = [ azurerm_linux_virtual_machine.example ]
}