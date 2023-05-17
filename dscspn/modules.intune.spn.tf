#
# DSC Creation
#

module "dsc_intune_spn" {
    source  = "./spn-module"

    service_principal_name = "dsc_intune_spn"
    service_principal_description = "Service Principal that manages the M365DSC intune Resource"

    enable_service_principal_certificate = false
    service_principal_password_rotation_in_years = 1

  # Adding roles and scope to service principal
  service_principal_assignments = [
    {
      scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
      role_definition_name = "Contributor"
    },
  ]

  # Adding Delegated Permission Grants
  service_principal_graph_permissions = [
    {
        id = "DeviceManagementConfiguration.ReadWrite.All"
        type = "Scope"
    },
    {
        id = "DeviceManagementApps.ReadWrite.All"
        type = "Scope"
    },
    {
        id = "DeviceManagementManagedDevices.ReadWrite.All"
        type = "Scope"
    },
    {
        id = "DeviceManagementRBAC.ReadWrite.All"
        type = "Scope"
    },
    {
        id = "DeviceManagementServiceConfig.ReadWrite.All"
        type = "Scope"
    },
    {
        id = "Policy.ReadWrite.CrossTenantAccess"
        type = "Scope"
    },
    {
        id = "Policy.ReadWrite.CrossTenantAccess"
        type = "Scope"
    },
  ]

  # Adding Directory Roles
  service_principal_directory_roles = [
    "3a2c62db-5318-420d-8d74-23affee5d9d5", // Intune Administrator
    "9f06204d-73c1-4d4c-880a-6edb90606fd8",  // AzureAD Joined Device Local Administrator
    "7698a772-787b-4ac8-901f-60d6b08affd2" // Cloud Device Administrator
  ]
}