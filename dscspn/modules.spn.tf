#
# DSC Creation
#

module "dsc_spn" {
    source  = "./spn-module"

    service_principal_name = "dsc_spn"
    service_principal_description = "Service Principal that manages the M365DSC"

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
        id = "openid"
        type = "Scope"
    },
    {
        id = "User.Read"
        type = "Scope"
    },
  ]

  # Adding Directory Roles
  service_principal_directory_roles = [
    "fdd7a751-b60b-444a-984c-02652fe8fa1c",
    "4d6ac14f-3453-41d0-bef9-a3e0c569773a"
  ]
}