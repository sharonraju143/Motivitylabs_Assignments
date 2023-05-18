terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.0.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "Demo-RG" {
  name     = "Demo-RG"
  location = "East US"
}

resource "azurerm_virtual_network" "Demo_Vnet" {
  name                = "Demo_Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Demo-RG.location
  resource_group_name = azurerm_resource_group.Demo-RG.name
}

resource "azurerm_subnet" "Demo_public_subnet_1" {
  name                 = "Demo_public_subnet_1"
  resource_group_name  = azurerm_resource_group.Demo-RG.name
  virtual_network_name = azurerm_virtual_network.Demo_Vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "Demo_public_subnet_2" {
  name                 = "Demo_public_subnet_2"
  resource_group_name  = azurerm_resource_group.Demo-RG.name
  virtual_network_name = azurerm_virtual_network.Demo_Vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "Demo_private_subnet_3" {
  name                 = "Demo_private_subnet_3"
  resource_group_name  = azurerm_resource_group.Demo-RG.name
  virtual_network_name = azurerm_virtual_network.Demo_Vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "Demo_private_subnet_4" {
  name                 = "Demo_public_subnet_4"
  resource_group_name  = azurerm_resource_group.Demo-RG.name
  virtual_network_name = azurerm_virtual_network.Demo_Vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}

resource "azurerm_automation_account" "Demo-account" {
  name                = "Demo-account"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.Demo-RG.name
  sku_name            = "Basic"
}

resource "azurerm_automation_schedule" "example" {
  name                    = "tfex-automation-schedule"
  resource_group_name     = azurerm_resource_group.Demo-RG.name
  automation_account_name = azurerm_automation_account.Demo-account.name
  frequency               = "Week"
  interval                = 1
  timezone                = "Australia/Perth"
  start_time              = "2014-04-15T18:00:15+02:00"
  description             = "This is an example schedule"
  week_days               = ["Friday"]
}



