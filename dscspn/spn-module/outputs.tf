# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

output "service_principal_name" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = azuread_service_principal.sp.display_name
}

output "service_principal_object_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = azuread_service_principal.sp.object_id
}

output "service_principal_application_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = azuread_service_principal.sp.application_id
}

output "client_id" {
  description = "The application id of AzureAD application created."
  value       = azuread_application.app.application_id
}

output "client_secret" {
  description = "Password for service principal."
  value       = azuread_service_principal_password.sp_password.*.value
  sensitive   = true
}

output "service_principal_password" {
  description = "Password for service principal."
  value       = azuread_service_principal_password.sp_password.*.value
  sensitive   = true
}

output "time_rotation" {
  description = "Timestamp for certificate and password rotation"
  value = time_rotating.main.rotation_rfc3339
}

output "application_object_id" {
  description = "The Application Object ID"
  value = azuread_application.app.object_id
}