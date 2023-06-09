# Create bastion host resources
resource "azurerm_subnet" "snet-bastion" {
  count = var.var_bastion == "YES" ? 1 : 0
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg-asda-shared.name
  virtual_network_name = azurerm_virtual_network.vnet-asda-shared.name
  address_prefixes     = var.bastion_subent_address_prefix
}

resource "azurerm_public_ip" "pip-bastion" {
    //count = var.var_bastion == "YES" ? 1 : 0
    name                = "pip-bastion"
    location            = azurerm_resource_group.rg-asda-shared.location
    resource_group_name = azurerm_resource_group.rg-asda-shared.name
    allocation_method   = "Static"
    sku                 = "Standard"
    //depends_on = [ azurerm_subnet.snet-bastion ]
}

resource "azurerm_bastion_host" "bastion-shared" {
    count = var.var_bastion == "YES" ? 1 : 0
    name                = "bh-${var.business_unit}-${var.environment}"
    location            = azurerm_resource_group.rg-asda-shared.location
    resource_group_name = azurerm_resource_group.rg-asda-shared.name

    ip_configuration {
        name                 = "configuration"
        subnet_id            = azurerm_subnet.snet-bastion[count.index].id
        public_ip_address_id = azurerm_public_ip.pip-bastion.id
  }
  depends_on = [ azurerm_subnet.snet-bastion ]
}