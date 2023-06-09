#create azure firewall resources

resource "azurerm_subnet" "snet-firwall" {
  count = var.var_firewall == "YES" ? 1 : 0
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg-asda-shared.name
  virtual_network_name = azurerm_virtual_network.vnet-asda-shared.name
  address_prefixes     = var.firewall_subent_address_prefix
  #service_endpoints    = ["Microsoft.Storage","Microsoft.KeyVault","Microsoft.Sql"] 
}

resource "azurerm_public_ip" "pip-firewall" {
  name                = "pip-firewall"
  location            = azurerm_resource_group.rg-asda-shared.location
  resource_group_name = azurerm_resource_group.rg-asda-shared.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fw-shared" {
    count = var.var_firewall == "YES" ? 1 : 0
    name                = "fw${var.business_unit}${var.environment}"
    location            = azurerm_resource_group.rg-asda-shared.location
    resource_group_name = azurerm_resource_group.rg-asda-shared.name
    sku_name            = "AZFW_VNet"
    sku_tier            = "Standard"

    ip_configuration {
        name                 = "configuration"
        subnet_id            = azurerm_subnet.snet-firwall[count.index].id
        public_ip_address_id = azurerm_public_ip.pip-firewall.id
    }
    firewall_policy_id = azurerm_firewall_policy.fwpolicy-shared.id
}

#create azure policy
resource "azurerm_firewall_policy" "fwpolicy-shared" {
  name                = "fwpolicy-${var.business_unit}-${var.resoure_group_location}"
  resource_group_name = azurerm_resource_group.rg-asda-shared.name
  location            = azurerm_resource_group.rg-asda-shared.location
}

#create shared ip group
resource "azurerm_ip_group" "ipg-shared" {
  name                = "ipg-shared"
  location            = azurerm_resource_group.rg-asda-shared.location
  resource_group_name = azurerm_resource_group.rg-asda-shared.name

  cidrs = var.core_subent_address_prefix

  /*tags = {
    environment = "Production"
  }*/
}

#create rule colleciton groups
resource "azurerm_firewall_policy_rule_collection_group" "fw-rcgs-shared" {
  name               = "rcg-${var.business_unit}-${var.environment}"
  firewall_policy_id = azurerm_firewall_policy.fwpolicy-shared.id
  priority           = 4000
  application_rule_collection {
    name     = "rc-${var.business_unit}-${var.environment}-application"
    priority = 3000
    action   = "Allow"
    rule {
      name = "allow-shared-shir"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = azurerm_ip_group.ipg-shared.cidrs//["10.0.0.6"] #replace this with actual ip address of SHIR private ip
      destination_fqdns = ["*"]
    }
  }

   network_rule_collection {
    name     = "rc-${var.business_unit}-${var.environment}-network"
    priority = 4000
    action   = "Allow"
    rule {
      name                  = "allow-azure-cloud"
      protocols             = ["TCP","UDP"]
      source_addresses      = azurerm_ip_group.ipg-shared.cidrs//["10.0.0.1"] #replace it with actual
      destination_addresses = ["*"]
      destination_ports     = ["44"]
    }
  }

  /*nat_rule_collection {
    name     = "nat_rule_collection1"
    priority = 300
    action   = "Dnat"
    rule {
      name                = "nat_rule_collection1_rule1"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["10.0.0.1", "10.0.0.2"]
      destination_address = "192.168.1.1"
      destination_ports   = ["80"]
      translated_address  = "192.168.0.1"
      translated_port     = "8080"
    }
  }*/
}