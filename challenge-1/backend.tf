terraform {
  backend "azurerm" {
    subscription_id      = "" #Add your own sub ID here.
    resource_group_name  = "tfstate-rg-mgmt"
    storage_account_name = "tfstatesamgmt"
    container_name       = "ttc-tfstate"
    key                  = "terraform.tfstate"
  }
}