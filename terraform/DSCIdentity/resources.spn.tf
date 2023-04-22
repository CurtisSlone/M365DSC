
# SPN Creation
resource "azuread_service_principal" "spn" {
    depends_on = [
      azuread_application.app
    ]
  application_id               = azuread_application.app.id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# SPN password
resource "azuread_service_principal_password" "spn_pass" {
  service_principal_id = azuread_service_principal.spn.id
}

# Add SPN to DSC groups
resource "azuread_group_member" "DSCGroup" {
  group_object_id  = data.azuread_group.DSCAdmins.object_id
  member_object_id = azuread_service_principal.spn.object_id
}