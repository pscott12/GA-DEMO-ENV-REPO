resource "azurerm_resource_group" "network" {
  # This resource group is for the linuxvm 
  name     = "rg-${var.application_name_three}-${var.enviroment_name}"
  location = var.primary_location
}
