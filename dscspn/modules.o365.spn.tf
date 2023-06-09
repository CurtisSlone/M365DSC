#
# DSC Creation
#

module "dsc_o365_spn" {
    source  = "./spn-module"

    service_principal_name = "dsc_o365_spn"
    service_principal_description = "Service Principal that manages the M365DSC O365 Resource"

    enable_service_principal_certificate = false
    service_principal_password_rotation_in_years = 1

  # Adding roles and scope to service principal
  service_principal_assignments = [
    {
      scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
      role_definition_name = "Contributor"
    },
  ]

  # Has MsGraph Perms?
  has_graph_perms = true

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
    "fdd7a751-b60b-444a-984c-02652fe8fa1c", // Groups Administrator
    "7698a772-787b-4ac8-901f-60d6b08affd2" // Cloud Device Administrator
  ]
}