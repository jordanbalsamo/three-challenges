resource "azurerm_resource_group" "ttc_rg" {
  name     = "${local.project_name}-rg-${var.environment}"
  location = "UK South"
}

resource "azurerm_storage_account" "static_site_sa" {
  name                     = "${local.project_name}staticsitesa${var.environment}"
  resource_group_name      = azurerm_resource_group.ttc_rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "GRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }

  tags = {
    managed_by   = local.managed_by
    owner        = local.ops_owner
    project_name = local.project_name
    environment  = var.environment
  }
}

resource "azurerm_storage_blob" "static_site_index_blob" {
  name                   = var.index_html
  storage_account_name   = azurerm_storage_account.static_site_sa.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "src/index.html"
}

resource "azurerm_storage_blob" "static_site_404_blob" {
  name                   = var.error_404
  storage_account_name   = azurerm_storage_account.static_site_sa.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "src/error_404.html"
}