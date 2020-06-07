# VNET
resource "azurerm_virtual_network" "ttc_vnet" {
  name                = "${var.project_name}-vnet-${var.environment}"
  address_space       = ["10.0.0.0/12"]
  location            = var.location
  resource_group_name = azurerm_resource_group.ttc_rg.name
  # dns_servers         = ["168.63.129.16"] 

  tags = local.default_tags
}

# Application Gateway Subnet
resource "azurerm_subnet" "ttc_agw_subnet" {
  name                 = "${var.project_name}-agw-subnet-${var.environment}"
  resource_group_name  = azurerm_resource_group.ttc_rg.name
  virtual_network_name = azurerm_virtual_network.ttc_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

# Given more time, I'd want to create a data tier subnet and place primary / secondary SQL Servers in a subnet
# and make it only accessible to the function app via a service endpoint. I'd achieve this through by following
# the following doc https://www.terraform.io/docs/providers/azurerm/r/sql_virtual_network_rule.html.

# Public IP address
resource "azurerm_public_ip" "ttc_pip" {
  name                = "${var.project_name}-pip-${var.environment}"
  resource_group_name = azurerm_resource_group.ttc_rg.name
  location            = var.location
  allocation_method   = "Dynamic"

  tags = local.default_tags
}

# App Gateway
resource "azurerm_application_gateway" "ttc_agw" {
  name                = "${var.project_name}-agw-${var.environment}"
  resource_group_name = azurerm_resource_group.ttc_rg.name
  location            = var.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 1
  }

  ssl_certificate {
    name     = "ssl-cert"
    data     = base64encode(file("${var.ssl_cert_file_path}"))
    password = var.ssl_cert_password
  }

  gateway_ip_configuration {
    name      = "${var.project_name}-ip-config-${var.environment}"
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
    name         = local.backend_address_pool_name
    ip_addresses = [azurerm_storage_account.static_site_sa.primary_blob_endpoint]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
    probe_name            = local.frontend_probe
    host_name             = azurerm_storage_account.static_site_sa.primary_blob_endpoint
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    host_name                      = azurerm_storage_account.static_site_sa.primary_blob_endpoint
    ssl_certificate_name           = "ssl-cert"
    protocol                       = "Https"
  }

  probe {
    name                = "frontend-probe"
    protocol            = "Http"
    path                = "/"
    host                = azurerm_storage_account.static_site_sa.primary_blob_endpoint
    interval            = 10
    timeout             = 30
    unhealthy_threshold = 3
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  tags = local.default_tags
}