data "azuread_group" "DSCAdmins" {
  display_name     = "M365DscAdmins"
  security_enabled = true
}
# Azure Resource Manager Data Source
data "azurerm_client_config" "current" {
}

# Azure AD Data Source
data "azuread_client_config" "current" {
}

