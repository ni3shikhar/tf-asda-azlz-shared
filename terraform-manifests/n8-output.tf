output "output_firewall_ip_address" {
  value = azurerm_public_ip.pip-firewall.id
}

output "output_vnet-asda-shared" {
  value = azurerm_virtual_network.vnet-asda-shared
}

output "output_vnet_cidr" {
  value = azurerm_virtual_network.vnet-asda-shared.address_space
}




