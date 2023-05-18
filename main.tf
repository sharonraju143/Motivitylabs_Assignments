terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "Sample-rg" {
  name     = "Sample-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "sample-vnet" {
  name                = "sample-vnet"
  resource_group_name = azurerm_resource_group.Sample-rg.name
  location            = azurerm_resource_group.Sample-rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "sample-public-subnet-1" {
  name                 = "sample-public-subnet-1"
  resource_group_name  = azurerm_resource_group.Sample-rg.name
  virtual_network_name = azurerm_virtual_network.sample-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "sample-public-subnet-2" {
  name                 = "sample-public-subnet-2"
  resource_group_name  = azurerm_resource_group.Sample-rg.name
  virtual_network_name = azurerm_virtual_network.sample-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "sample-private-subnet-1" {
  name                 = "sample-private-subnet-1"
  resource_group_name  = azurerm_resource_group.Sample-rg.name
  virtual_network_name = azurerm_virtual_network.sample-vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "sample-private-subnet-2" {
  name                 = "sample-private-subnet-2"
  resource_group_name  = azurerm_resource_group.Sample-rg.name
  virtual_network_name = azurerm_virtual_network.sample-vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}

resource "azurerm_route_table" "sample-public-rt" {
  name                          = "sample-public-rt"
  location                      = azurerm_resource_group.Sample-rg.location
  resource_group_name           = azurerm_resource_group.Sample-rg.name
  disable_bgp_route_propagation = false

  route {
    name           = "route1"
    address_prefix = "10.0.0.0/16"
    next_hop_type  = "VnetLocal"
  }

  tags = {
    environment = "Testing"
  }
}

resource "azurerm_subnet_route_table_association" "sample-public1-rta" {
  subnet_id      = azurerm_subnet.sample-public-subnet-1.id
  route_table_id = azurerm_route_table.sample-public-rt.id
}

resource "azurerm_subnet_route_table_association" "sample-public2-rta" {
  subnet_id      = azurerm_subnet.sample-public-subnet-2.id
  route_table_id = azurerm_route_table.sample-public-rt.id
}

