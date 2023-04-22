# Licensed under the MIT License.

output "spn_name" {
    value = azuread_service_principal.spn.display_name
}

output "app_name" {
    value = azuread_application.app.display_name
}

output "app_Id" {
    value = azuread_application.app.application_id
}
output "app_secret" {
    value = azuread_application_password.apppass.value
    sensitive = true
}

output "spn_Id" {
    value = azuread_application.app.application_id
}
output "spn_secret" {
    value = azuread_application_password.apppass.value
    sensitive = true
}

output "spn_group_id" {
    value = azuread_group_member.DSCGroup.group_object_id
}