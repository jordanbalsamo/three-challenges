# VNET
resource "azurerm_virtual_network" "ttc_vnet" {
  name                = "${local.project_name}-vnet-${var.environment}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.ttc_rg.name
  # dns_servers         = ["168.63.129.16"] 
}

# Application Gateway Subnet
resource "azurerm_subnet" "ttc_agw_subnet" {
  name                 = "${local.project_name}-agw-subnet-${var.environment}"
  resource_group_name  = azurerm_resource_group.ttc_rg.name
  virtual_network_name = azurerm_virtual_network.ttc_vnet.name
  address_prefixes       = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

# Public IP address
resource "azurerm_public_ip" "ttc_pip" {
  name                = "${local.project_name}-pip-${var.environment}"
  resource_group_name = azurerm_resource_group.ttc_rg.name
  location            = var.location
  allocation_method   = "Dynamic"
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.ttc_vnet.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.ttc_vnet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.ttc_vnet.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.ttc_vnet.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.ttc_vnet.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.ttc_vnet.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.ttc_vnet.name}-rdrcfg"
}

resource "azurerm_application_gateway" "ttc_agw" {
  name                = "${local.project_name}-agw-${var.environment}"
  resource_group_name = azurerm_resource_group.ttc_rg.name
  location            = var.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "${local.project_name}-ip-config-${var.environment}"
    subnet_id = azurerm_subnet.ttc_agw_subnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.ttc_pip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
    host_name             = azurerm_storage_account.static_site_sa.primary_blob_endpoint
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}