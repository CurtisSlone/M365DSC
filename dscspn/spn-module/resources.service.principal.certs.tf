# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azuread_service_principal_certificate" "main" {
  count                = var.enable_service_principal_certificate == true ? 1 : 0
  service_principal_id = azuread_service_principal.sp.id
  type                 = var.certificate_type
  encoding             = var.certificate_encoding
  key_id               = var.key_id
  value                = file(var.certificate_path)
  end_date             = time_rotating.main.id
}