provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "lbenninga-functions-python-rg"
  location = var.location
}

resource "azurerm_storage_account" "default" {
  name                     = var.storageaccount
  resource_group_name      = azurerm_resource_group.default.name
  location                 = azurerm_resource_group.default.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "default" {
  name                = "lbenninga-azure-functions-python-service-plan"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "default" {
  name                       = "lbenninga-python-test-functions"
  location                   = azurerm_resource_group.default.location
  resource_group_name        = azurerm_resource_group.default.name
  app_service_plan_id        = azurerm_app_service_plan.default.id
  storage_account_name       = azurerm_storage_account.default.name
  storage_account_access_key = azurerm_storage_account.default.primary_access_key
  os_type                    = "linux"
  version                    = "~3"
}
