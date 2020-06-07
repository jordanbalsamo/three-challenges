resource "azurerm_resource_group" "ttc_rg" {
  name     = "${var.project_name}-rg-${var.environment}"
  location = "UK South"

  tags = local.default_tags
}

resource "azurerm_storage_account" "static_site_sa" {
  name                     = "${var.project_name}staticsitesa${var.environment}"
  resource_group_name      = azurerm_resource_group.ttc_rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "GRS"
  access_tier = "Hot"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }

  # https://docs.microsoft.com/en-us/azure/storage/common/storage-network-security
  network_rules {
    default_action = "Allow"
    virtual_network_subnet_ids = [azurerm_subnet.ttc_agw_subnet.id]
  }

  tags = local.default_tags
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