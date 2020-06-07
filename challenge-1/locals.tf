# fixed vars that will be reused frequently
locals {

  #default tags. can use the merge() function on resource to add arbitrary additional tags
  default_tags = {
    managed_by   = "Terraform"
    owner        = "DevOps"
    project_name = var.project_name
    environment  = var.environment
  }

  backend_address_pool_name      = "${azurerm_virtual_network.ttc_vnet.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.ttc_vnet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.ttc_vnet.name}-feip"
  frontend_probe                 = "${azurerm_virtual_network.ttc_vnet.name}-feprobe"
  http_setting_name              = "${azurerm_virtual_network.ttc_vnet.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.ttc_vnet.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.ttc_vnet.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.ttc_vnet.name}-rdrcfg"

}