module "mod_dsc_admin" {
    source = "./DSCIdentity"
    spn_name = "DSCSPN"
    app_name = "DSCAPP"

}

# Outputs
output "spn_name" {
    value = module.mod_dsc_admin.spn_name
}

output "app_name" {
    value = module.mod_dsc_admin.app_name
}

output "app_Id" {
    value = module.mod_dsc_admin.app_Id
}
output "app_secret" {
    value = module.mod_dsc_admin.app_secret
    sensitive = true
}

output "spn_secret" {
    value = module.mod_dsc_admin.spn_secret
    sensitive = true
}

output "spn_Id" {
    value = module.mod_dsc_admin.spn_Id
}

output "spn_group_id" {
    value = module.mod_dsc_admin.spn_group_id
}


# Versions
terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.22"
    }
  }
}

provider "azurerm" {
  features {}
}