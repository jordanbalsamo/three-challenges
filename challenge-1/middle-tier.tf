resource "azurerm_storage_account" "ttc_function_sa" {
  name                     = "${var.project_name}fasa${var.environment}"
  resource_group_name      = azurerm_resource_group.ttc_rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.default_tags
}

resource "azurerm_app_service_plan" "ttc_plan" {
  name                = "${var.project_name}-plan-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.ttc_rg.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  tags = local.default_tags
}

resource "azurerm_function_app" "ttc_fa" {
  name                      = "${var.project_name}-fa-${var.environmentyes}"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.ttc_rg.name
  app_service_plan_id       = azurerm_app_service_plan.ttc_plan.id
  storage_account_name      = azurerm_storage_account.ttc_function_sa.name
  storage_connection_string = azurerm_storage_account.ttc_function_sa.primary_connection_string

  tags = local.default_tags
}