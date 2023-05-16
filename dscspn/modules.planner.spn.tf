#
# DSC Creation
#

module "dsc_planner_spn" {
    source  = "./spn-module"

    service_principal_name = "dsc_exchange_spn"
    service_principal_description = "Service Principal that manages the M365DSC planner Resource"

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
        id = "Tasks.ReadWrite"
        type = "Scope"
    },
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
  ]
}