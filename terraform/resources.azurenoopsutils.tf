# Licensed under the MIT License.

# Resource Group NoOpsUtils
resource "azurenoopsutils_resource_name" "rg" {
    name = "resourcegroup"
    resource_type = "azurerm_resource_group"
    prefixes        = []
    suffixes        = []
    random_length = 5
    clean_input = true
    separator     = "-"
}

# KV NSGNoOpsUtils
resource "azurenoopsutils_resource_name" "kv" {
    name = "keyvault"
    resource_type = "azurerm_key_vault"
    prefixes        = []
    suffixes        = []
    random_length = 5
    clean_input = true
    separator     = "-"
}