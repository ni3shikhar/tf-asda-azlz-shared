  #route table association to subnet
  resource "azurerm_subnet_route_table_association" "rt_assoc" {
  subnet_id      = azurerm_subnet.snet-core-shared.id
  route_table_id = azurerm_route_table.rt-shared-asda.id
  }