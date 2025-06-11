resource "azurerm_resource_group" "linuxvm" {
  # This resource group is for the linuxvm 
  name     = "rg-${var.application_name_three}-${var.enviroment_name}"
  location = var.primary_location
}

resource "azurerm_public_ip" "vm1" {
  name                = "pip-${var.application_name_three}-${var.enviroment_name}-vm1"
  resource_group_name = azurerm_resource_group.linuxvm.name
  location            = azurerm_resource_group.linuxvm.location
  allocation_method   = "Static"
}
