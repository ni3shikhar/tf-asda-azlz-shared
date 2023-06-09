#route table and routes
resource "azurerm_route_table" "rt-shared-asda" {
  name                          = "route-${var.business_unit}-${var.environment}-001"
  location                      = azurerm_resource_group.rg-asda-shared.location
  resource_group_name           = azurerm_resource_group.rg-asda-shared.name
  disable_bgp_route_propagation = false

  route {
    name           = "route-to-internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_public_ip.pip-firewall.ip_address
  }
  route {
    name           = "RFC_1918_10"
    address_prefix = "10.0.0.0/8"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_public_ip.pip-firewall.ip_address
  }
  route {
    name           = "RFC_1918_172"
    address_prefix = "172.16.0.0/12"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_public_ip.pip-firewall.ip_address
  }
  route {
    name           = "RFC_1918_192"
    address_prefix = "192.168.0.0/16"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_public_ip.pip-firewall.ip_address
  }

  /*tags = {
    environment = "Production"
  }*/
}