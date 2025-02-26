resource "random_pet" "lb_hostname" {

}

resource "azurerm_network_security_group" "nsg-training-poc" {
  name                = var.nsg-name
  location            = var.location
  resource_group_name = var.resource_group_name
  security_rule {
    name                       = "AllowHttp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowHttps"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allowssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "vnet-training-poc" {
  name                = var.vnet-name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet-training-poc" {
  name                 = "frontend"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-training-poc.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "nsga-training-poc" {
  subnet_id                 = azurerm_subnet.subnet-training-poc.id
  network_security_group_id = azurerm_network_security_group.nsg-training-poc.id
}

resource "azurerm_public_ip" "pb-training-poc" {
  name                = "lb-TestPublicIp1"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  domain_name_label   = "${azurerm_resource_group.rg-training-poc.name}-${random_pet.lb_hostname.id}"
}

resource "azurerm_lb" "lb-training-poc" {
  name                = "myLB"
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "myPublicIP"
    public_ip_address_id = azurerm_public_ip.pb-training-poc.id
  }
}

resource "azurerm_lb_backend_address_pool" "bckendLB-traiining-poc" {
  loadbalancer_id = azurerm_lb.lb-training-poc.id
  name            = "MyBackEndAddressPoolLB"
}

resource "azurerm_lb_probe" "probe-training-poc" {
  loadbalancer_id = azurerm_lb.lb-training-poc.id
  name            = "http-running-probe"
  port            = 80
  request_path    = "/"
}

resource "azurerm_lb_rule" "lbrule-training-poc" {
  loadbalancer_id                = azurerm_lb.lb-training-poc.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "myPublicIP"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bckendLB-traiining-poc.id]
  probe_id                       = azurerm_lb_probe.probe-training-poc.id
}

resource "azurerm_lb_nat_rule" "nat-training-poc" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.lb-training-poc.id
  name                           = "ssh"
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bckendLB-traiining-poc.id
  frontend_ip_configuration_name = "myPublicIP"
}

resource "azurerm_public_ip" "natgwpip" {
  name                = "natgw-TestPublicIp1"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

resource "azurerm_nat_gateway" "natgw-training-poc" {
  name                    = "nat-gateway-poc"
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

resource "azurerm_subnet_nat_gateway_association" "subnetgw-poc" {
  subnet_id      = azurerm_subnet.subnet-training-poc.id
  nat_gateway_id = azurerm_nat_gateway.natgw-training-poc.id
}

resource "azurerm_nat_gateway_public_ip_association" "subnetpublic-poc" {
  nat_gateway_id       = azurerm_nat_gateway.natgw-training-poc.id
  public_ip_address_id = azurerm_public_ip.natgwpip.id
}
