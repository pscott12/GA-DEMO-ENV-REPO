resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.enviroment_name}"
  location = var.primary_location

}

resource "random_string" "suffix" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_storage_account" "main" {
  name                     = "st${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

}

resource "azurerm_storage_container" "GA-DEMO-STORAGE" {
  name                  = "StorageContainer"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}
