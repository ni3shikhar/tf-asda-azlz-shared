# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "rg-asda-shared" {
  #name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  #name = local.rg_name
  name = "rg-${var.business_unit}-${var.environment}"
  location = var.resoure_group_location
  #tags = var.common_tags
}

# Create Virtual Network
resource "azurerm_virtual_network" "vnet-asda-shared" {
  name                = "vnet-${var.business_unit}-${var.environment}"
  address_space       = var.vnet_address_space_asda_shared
  location            = azurerm_resource_group.rg-asda-shared.location
  resource_group_name = azurerm_resource_group.rg-asda-shared.name
  #tags = var.common_tags 
}

resource "azurerm_subnet" "snet-core-shared" {
  name                 = "snet-core"
  resource_group_name  = azurerm_resource_group.rg-asda-shared.name
  virtual_network_name = azurerm_virtual_network.vnet-asda-shared.name
  address_prefixes     = var.core_subent_address_prefix
  #service_endpoints    = ["Microsoft.Storage","Microsoft.KeyVault","Microsoft.Sql"]
}

#create storage account for shared activities
resource "azurerm_storage_account" "stg-asda-shared" {
  name                     = "stglog${var.business_unit}${var.environment}${random_string.random.id}"
  resource_group_name      = azurerm_resource_group.rg-asda-shared.name
  location                 = azurerm_resource_group.rg-asda-shared.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  #public_network_access_enabled = true 

  /* {
    default_action             = "Deny"
    ip_rules                   = ["159.246.20.2","159.246.40.2"]
    virtual_network_subnet_ids = [azurerm_subnet.snet-core.id,azurerm_subnet.snet-privateendpoints.id]
    bypass                     = ["Metrics"]
  }*/

  /*tags = {
    environment = "staging"
  }*/
}
resource "random_string" "random" {
  length           = 6
  special = false
  upper = false
  numeric = false
}

