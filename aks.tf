provider "azurerm" {
  features {}
}

locals {
  name               = "${var.naming_prefix}-aks"
  agents_count       = [2,2]
  agents_size        = "Standard_D2s_v3"
  base_address_space = "10.42.0.0/16" # Don't use 10.0.0.0/16 as the module uses it for K8s
}

resource "azurerm_resource_group" "main" {
  name     = local.name
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  count               = var.cluster_count
  address_space       = [cidrsubnet(local.base_address_space, 8, count.index)]
  location            = azurerm_resource_group.main.location
  name                = "${local.name}-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  count                = var.cluster_count
  address_prefixes     = [cidrsubnet(local.base_address_space, 8, count.index)]
  name                 = "${local.name}-nodes"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main[count.index].name
}

module "clusters" {
  count   = var.cluster_count
  source  = "Azure/aks/azurerm"
  version = "~>6.0"

  prefix                            = "${var.naming_prefix}${count.index}"
  resource_group_name               = azurerm_resource_group.main.name
  agents_count                      = local.agents_count[count.index]
  agents_size                       = local.agents_size
  vnet_subnet_id                    = azurerm_subnet.main[count.index].id
  sku_tier                          = "Paid"
  rbac_aad                          = false
  rbac_aad_managed                  = false
  role_based_access_control_enabled = true

  depends_on = [
    azurerm_resource_group.main
  ]

}