terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateprod01"
    container_name       = "state"
    key                  = "datetime/multiregion.tfstate"
  }
}

