# Input Variables

# 1. Business Unit Name
variable "business_unit" {
  description = "Business Unit Name"
  type = string
  default = "crw"
}
# 2. Environment Name
variable "environment" {
  description = "Environment Name"
  type = string
  default = "shared"
}

# 3. Resource Group Location
variable "resoure_group_location" {
  description = "Resource Group Location"
  type = string
  default = "eastus"
}

# 4. Virtual Network Address - Dev
variable "vnet_address_space_asda_shared" {
  description = "Virtual Network Address Space for Shared Environment"
  type = list(string)
  default = [ "10.0.0.0/24" ]
}

# want to create bastion?
variable "var_bastion" {
  description = "Set as YES if want to create Azure Bastion setup"
  type = string
  default = "YES"
}

# 5. bastion subnet
variable "bastion_subent_address_prefix" {
  description = "Address prefix of the bastion subnet."
  type = list(string)
  default = [ "10.0.0.128/26" ]
}

# want to create firewall?
variable "var_firewall" {
  description = "Set as YES if want to create Azure Firewall setup"
  type = string
  default = "YES"
}

# 6. firewall subnet
variable "firewall_subent_address_prefix" {
  description = "Address prefix of the firewall subnet."
  type = list(string)
  default = [ "10.0.0.64/26" ]
}

# want to create gateway?
variable "var_gateway" {
  description = "Set as YES if want to create Gateway setup"
  type = string
  default = "NO"
}

# 7. gateway subnet
variable "gateway_subent_address_prefix" {
  description = "Address prefix of the gateway subnet."
  type = list(string)
  default = [ "10.0.0.0/27" ]
}

#core subnet - SHIR
# 6. firewall subnet
variable "core_subent_address_prefix" {
  description = "Address prefix for compute resources like shared SHIR"
  type = list(string)
  default = [ "10.0.0.192/27"] #update appropriately
}
