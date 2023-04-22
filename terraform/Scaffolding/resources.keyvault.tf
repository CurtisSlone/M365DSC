#------------------------------------------------------------
# Key Vault configuration - Default (required). 
#------------------------------------------------------------
resource "azurerm_key_vault" "keyvault" {
  
  depends_on = [
    azurerm_resource_group.rg
  ]
  # Globals
  name = local.kv_name
  location = local.location
  resource_group_name = local.rg_name
  tenant_id = local.tenant_id
  sku_name = "standard"

  # Keyvault Configurations - Hard Coded
  enabled_for_disk_encryption = false
  enable_rbac_authorization = false
  public_network_access_enabled = true

  # Keyvault Configurations - Vars
  purge_protection_enabled = false
  soft_delete_retention_days = 7
}

# Remote State Creator Perms
resource "azurerm_key_vault_access_policy" "admin_policy" {
  depends_on = [
    azurerm_key_vault.keyvault
  ]

   tenant_id = local.tenant_id
   object_id = data.azurerm_client_config.current.object_id
   key_vault_id = azurerm_key_vault.keyvault.id 

   key_permissions = [
        "Get",
        "List",
        "Create",
        "Delete",
        "Purge"
    ]
    secret_permissions = [
        "Get",
        "List",
        "Set",
        "Delete",
        "Purge",
        "Recover"

        ]

        storage_permissions = [
        "Get",
        "GetSAS",
        "SetSAS",
        "Delete",
        "Purge"

        ]
 }
 
 # App Policy
resource "azurerm_key_vault_access_policy" "app" {
  depends_on = [
    azurerm_key_vault.keyvault
  ]

  object_id = var.spn_id
  tenant_id = local.tenant_id
  key_vault_id = azurerm_key_vault.keyvault.id

 key_permissions = [
        "Get",
        "List"
    ]
    secret_permissions = [
        "Get",
        "List"
        ]

    storage_permissions = [
    "Get",
    "GetSAS",
    "List",
    "ListSAS"
    ]
}