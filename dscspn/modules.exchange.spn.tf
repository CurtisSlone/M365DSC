#
# DSC Creation
#

module "dsc_exchange_spn" {
    source  = "./spn-module"

    service_principal_name = "dsc_exchange_spn"
    service_principal_description = "Service Principal that manages the M365DSC exchange Resource"

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
  service_principal_graph_permissions = []

  # Adding Directory Roles
  service_principal_directory_roles = [
    "29232cdf-9323-42fd-ade2-1d097af3e4de", // Exchange Administrator
    "31392ffb-586c-42d1-9346-e59415a2cc4e",  // Exchange Recipient Administrator
    "194ae4cb-b126-40b2-bd5b-6091b380977d" // Security Administrator
  ]
}