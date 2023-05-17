#
# DSC Creation
#

module "dsc_security_compliance_spn" {
    source  = "./spn-module"

    service_principal_name = "dsc_security_compliance_spn"
    service_principal_description = "Service Principal that manages the M365DSC securitycenter Resource"

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
        id = "Policy.Read.All"
        type = "Scope"
    },
  ]

  # Adding Directory Roles
  service_principal_directory_roles = [
    "194ae4cb-b126-40b2-bd5b-6091b380977d", // Security Administrator
  ]
}