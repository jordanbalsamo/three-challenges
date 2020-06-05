#Default provider
provider "azurerm" {
  version         = "=v2.13.0"
  subscription_id = "" # add your own sub ID here
  features {}

}

#Aliased providers
provider "azurerm" {
  alias           = "core"
  version         = "=v2.13.0"
  subscription_id = "" # add your own sub ID here
  features {}

}

# mocked - would be implemented in a centrally managed location and called upon
/*
provider "azurerm" {
  alias           = "kv"
  version         = "=v2.13.0"
  subscription_id = "" # add your own sub ID here
  features        = {}
}
*/

provider "random" {
  alias   = "random"
  version = "~> 2.2"
}