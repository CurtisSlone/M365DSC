# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azuread_application" "app" {
  display_name     = var.service_principal_name
  identifier_uris  = var.identifier_uris
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = var.sign_in_audience

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    dynamic "resource_access" {
      for_each = var.service_principal_graph_permissions

      content {
        id = azuread_service_principal.msgraph.oauth2_permission_scope_ids[resource_access.value.id]
        type = resource_access.value.type
      }
    }
  }
}

resource "azuread_service_principal" "sp" {
  application_id    = azuread_application.app.application_id
  owners            = [data.azuread_client_config.current.object_id]
  alternative_names = var.alternative_names
  description       = var.service_principal_description
}

resource "azuread_service_principal_delegated_permission_grant" "spn_permission_grant" {
  depends_on = [ 
    azuread_service_principal.sp,
    azuread_service_principal.msgraph
   ]
  service_principal_object_id          = azuread_service_principal.sp.object_id
  resource_service_principal_object_id = azuread_service_principal.msgraph.object_id
  claim_values                         = flatten([
    for obj in var.service_principal_graph_permissions :
    [obj.id]
  ])
}



