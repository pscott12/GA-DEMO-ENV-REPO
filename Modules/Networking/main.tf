resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.enviroment_name}"
  location = var.primary_location


}
