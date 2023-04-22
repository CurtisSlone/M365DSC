

# DSC LCM APP
resource "azuread_application" "app" {
  display_name = local.app_name
  owners       = [data.azuread_client_config.current.object_id]
}