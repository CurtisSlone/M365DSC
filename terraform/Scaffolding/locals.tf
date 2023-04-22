# Licensed under the MIT License.

# 
locals {
  tenant_id = data.azurerm_client_config.current.tenant_id
  subscription_id = "subscriptions/${data.azurerm_client_config.current.subscription_id}"
}