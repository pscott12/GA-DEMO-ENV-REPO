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
  alphha_address_space  = cidrsubnet(var.base_address_space, 2, 0)
  bravo_address_space   = cidrsubnet(var.base_address_space, 2, 1)
  charlie_address_space = cidrsubnet(var.base_address_space, 2, 2)
  delta_address_space   = cidrsubnet(var.base_address_space, 2, 3)
}

resource "azurerm_subnet" "alpha" {
  name                 = "snet-alpha"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.108.0.0/24"]
}

// 10.108.1.0/24
resource "azurerm_subnet" "bravo" {
  name                 = "snet-bravo"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.108.1.0/24"]
}

// 10.108.2.0/24
resource "azurerm_subnet" "charlie" {
  name                 = "snet-charlie"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.108.2.0/24"]
}

// 10.108.3.0/24
resource "azurerm_subnet" "delta" {
  name                 = "snet-delta"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.108.3.0/24"]
}

