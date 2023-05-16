# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_role_assignment" "role" {
  count                = length(var.service_principal_assignments)
  name                 = var.azure_role_name
  description          = var.azure_role_description
  scope                = var.service_principal_assignments[count.index].scope
  role_definition_name = var.service_principal_assignments[count.index].role_definition_name
  principal_id         = azuread_service_principal.sp.object_id
}