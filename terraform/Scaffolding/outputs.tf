# Licensed under the MIT License.

output "resource_group" {
    value = azurerm_resource_group.rg.name
}

output "keyvault" {
    value = azurerm_key_vault.keyvault.name
}