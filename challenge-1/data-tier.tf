# generate a random sql admin password
resource "random_password" "sql_server_admin_password" {
  provider         = random.random
  length           = 32
  upper            = true
  lower            = true
  number           = true
  special          = true
  override_special = "_%@"
}

# mocked - would be implemented in a centrally managed location and called upon via KV in other parts of infra estate / pipelines
/*
resource "azurerm_key_vault_secret" "sql_server_admin_password" {
  provider = azurerm.kv
  name     = "${local.project_name}-sqlserver-${var.environment}-administrator-password"
  value    = random_password.sql_server_admin_password
}
*/

resource "azurerm_sql_server" "primary_server" {
  name                         = "${var.project_name}-sqlserver-${var.environment}"
  resource_group_name          = azurerm_resource_group.ttc_rg.name
  location                     = var.location
  version                      = var.sql_server_version
  administrator_login          = var.sql_server_administrator_login
  administrator_login_password = random_password.sql_server_admin_password.result

  extended_auditing_policy {
    storage_endpoint           = azurerm_storage_account.sql_audit_logs.primary_blob_endpoint
    storage_account_access_key = azurerm_storage_account.sql_audit_logs.primary_access_key
    retention_in_days          = 365
  }

  tags = merge(local.default_tags, { "failover" = "failover" })
}

resource "azurerm_storage_account" "sql_audit_logs" {
  name                     = "${var.project_name}sa${var.environment}"
  resource_group_name      = azurerm_resource_group.ttc_rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.default_tags
}

resource "azurerm_sql_database" "primary_db" {
  name                = "${var.project_name}-sqldb-${var.environment}"
  resource_group_name = azurerm_resource_group.ttc_rg.name
  location            = var.location
  server_name         = azurerm_sql_server.primary_server.name
  edition             = var.sql_db_edition

  extended_auditing_policy {
    storage_endpoint           = azurerm_storage_account.sql_audit_logs.primary_blob_endpoint
    storage_account_access_key = azurerm_storage_account.sql_audit_logs.primary_access_key
    retention_in_days          = 365
  }

  tags = merge(local.default_tags, { "failover" = "primary" })
}

resource "azurerm_sql_server" "failover_server" {
  count                        = var.environment == "prod" ? 1 : 0
  name                         = "${var.project_name}-sqlserver-replica-${var.environment}"
  resource_group_name          = azurerm_resource_group.ttc_rg.name
  location                     = var.failover_location
  version                      = var.sql_server_version
  administrator_login          = var.sql_server_administrator_login
  administrator_login_password = random_password.sql_server_admin_password.result

  extended_auditing_policy {
    storage_endpoint           = azurerm_storage_account.sql_audit_logs.primary_blob_endpoint
    storage_account_access_key = azurerm_storage_account.sql_audit_logs.primary_access_key
    retention_in_days          = 365
  }

  tags = merge(local.default_tags, { "failover" = "failover" })

  depends_on = [azurerm_sql_server.primary_server]
}

resource "azurerm_sql_database" "failover_db" {
  count               = var.environment == "prod" ? 1 : 0
  name                = "${var.project_name}-sqldb-replica-${var.environment}"
  create_mode         = "OnlineSecondary"
  source_database_id  = azurerm_sql_database.primary_db.id
  resource_group_name = azurerm_resource_group.ttc_rg.name
  location            = var.failover_location
  server_name         = azurerm_sql_server.primary_server.name
  edition             = var.sql_db_edition

  tags = merge(local.default_tags, { "failover" = "failover" })

  depends_on = [azurerm_sql_server.primary_server, azurerm_sql_database.primary_db]
}

resource "azurerm_sql_failover_group" "failover_group" {
  count               = var.environment == "prod" ? 1 : 0
  name                = "${var.project_name}-fg-${var.environment}"
  resource_group_name = azurerm_resource_group.ttc_rg.name
  server_name         = azurerm_sql_server.primary_server.name
  databases           = [azurerm_sql_database.primary_db.id]
  partner_servers {
    id = azurerm_sql_server.failover_server[count.index].id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = "60"
  }

  readonly_endpoint_failover_policy {
    mode = "Disabled"
  }

  tags = merge(local.default_tags, { "failover" = "failover" })
}
