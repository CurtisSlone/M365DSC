#
# DSC Creation
#

module "dsc_sharepoint_spn" {
    source  = "./spn-module"

    service_principal_name = "dsc_exchange_spn"
    service_principal_description = "Service Principal that manages the M365DSC sharepoint Resource"

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
        id = "Group.ReadWrite.All"
        type = "Scope"
    },
    {
        id = "User.Read.All"
        type = "Scope"
    },
  ]

  # Adding Directory Roles
  service_principal_directory_roles = [
    "69091246-20e8-4a56-aa4d-066075b2a7a8", // Teams Administrator
    "baf37b3a-610e-45da-9e62-d9d1e5e8914b", // Teams Communications Administrator
    "3d762c5a-1b6c-493f-843e-55a3b42923d4" // Teams Devices Administrator
  ]
}

