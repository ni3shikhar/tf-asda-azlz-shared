# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
  } 
# Terraform State Storage to Azure Storage Container
  backend "azurerm" {
    resource_group_name   = "rg-terraform-storage-state"
    storage_account_name  = "stgnmsterraformstate"
    container_name        = "tfstatefiles"
    key                   = "state-crw-asda-lz-shared.tfstate"
  }   
}

# Provider Block
provider "azurerm" {
 features {
  key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
 }          
}



