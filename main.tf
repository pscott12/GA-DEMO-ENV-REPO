data "azurerm_client_config" "current" {}

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
  name                  = "storagecontainer"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${var.application_name}-${var.enviroment_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "random_string" "keyvault_suffix" {
  length  = 6
  special = false
  upper   = false

}

resource "azurerm_key_vault" "main" {
  name                = "kv-${var.application_name}-${var.enviroment_name}-${random_string.keyvault_suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
}


data "azurerm_log_analytics_workspace" "main" {
  name                = "log-${var.application_name}-${var.enviroment_name}"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  name               = "diag-${var.application_name}-${var.enviroment_name}-${random_string.keyvault_suffix.result}"
  target_resource_id = azurerm_key_vault.main.id
  storage_account_id = azurerm_storage_account.main.id

  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.main.id

  enabled_log {
    category_group = "audit"
  }

  enabled_log {
    category_group = "alllogs"
  }

  metric {
    category = "AllMetrics"
  }
}
