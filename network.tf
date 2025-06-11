resource "azurerm_resource_group" "network" {
  # This resource group is for the network resources
  name     = "rg-${var.application_name}-${var.enviroment_name}"
  location = var.primary_location
}
