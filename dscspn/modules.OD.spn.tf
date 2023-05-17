#
# DSC Creation
#

module "dsc_OD_spn" {
    source  = "./spn-module"

    service_principal_name = "dsc_od_spn"
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
        id = "Sites.FullControl.All"
        type = "Scope"
    },
  ]
}