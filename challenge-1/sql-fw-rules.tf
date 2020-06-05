resource "azurerm_sql_firewall_rule" "firewall" {
  count               = var.allow_trusted_azure_services ? 1 : 0
  name                = "AllowTrustedAzureServices"
  resource_group_name = azurerm_resource_group.ttc_rg.name
  server_name         = azurerm_sql_server.primary_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
  depends_on          = [azurerm_sql_server.primary_server]
}

resource "azurerm_sql_firewall_rule" "failover_firewall" {
  count               = var.allow_trusted_azure_services && var.environment == "prod" ? 1 : 0
  name                = "AllowTrustedAzureServices"
  resource_group_name = azurerm_resource_group.ttc_rg.name
  server_name         = azurerm_sql_server.failover_server[count.index].name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
  depends_on          = [azurerm_sql_server.failover_server]
}