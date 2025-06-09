resource "azurerm_resource_group" "rg" {
  name     = "appgw_vmss-resources"
  location = "Poland Central"
}

resource "azurerm_virtual_network" "vnet_vmss" {
  name                = "appgw_vmss-vnet"
  address_space       = ["172.20.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "vmss" {
  name                 = "vmss-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_vmss.name
  address_prefixes     = ["172.20.2.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "vmss-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
