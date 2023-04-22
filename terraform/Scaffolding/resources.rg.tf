# Licensed under the MIT License.

# M365DSC Resource Group
resource "azurerm_resource_group" "rg" {
  name = local.rg_name
  location = local.location
  tags = local.default_tags
}