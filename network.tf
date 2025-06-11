resource "azurerm_resource_group" "network" {
  # This resource group is for the network resources
  name     = "rg-${var.application_name_two}-${var.enviroment_name}"
  location = var.primary_location
}


resource "azurerm_virtual_network" "network" {
  name                = "vnet-${var.application_name_two}-${var.enviroment_name}"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = [var.base_address_space]
}

locals {
  alpha_address_space   = cidrsubnet(var.base_address_space, 2, 0)
  bravo_address_space   = cidrsubnet(var.base_address_space, 2, 1)
  charlie_address_space = cidrsubnet(var.base_address_space, 2, 2)
  delta_address_space   = cidrsubnet(var.base_address_space, 2, 3)
}

resource "azurerm_subnet" "alpha" {
  name                 = "snet-alpha"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = [local.alpha_address_space]
}

// 10.108.1.0/24
resource "azurerm_subnet" "bravo" {
  name                 = "snet-bravo"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = [local.bravo_address_space]
}

// 10.108.2.0/24
resource "azurerm_subnet" "charlie" {
  name                 = "snet-charlie"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = [local.charlie_address_space]
}

// 10.108.3.0/24
resource "azurerm_subnet" "delta" {
  name                 = "snet-delta"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = [local.delta_address_space]
}

resource "azurerm_network_security_group" "remote_access" {
  name                = "nsg-${var.application_name_two}-${var.enviroment_name}-remote-access"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = chomp(data.http.my_ip.body)
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "alpha_remote_access" {
  subnet_id                 = azurerm_subnet.alpha.id
  network_security_group_id = azurerm_network_security_group.remote_access.id
}

data "http" "my_ip" {
  url = "http://ipinfo.io/ip"
}
