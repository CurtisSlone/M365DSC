# Licensed under the MIT License.

output "spn_name" {
    value = azuread_service_principal.spn.display_name
}

output "app_name" {
    value = azuread_application.app.display_name
}

output "spn_secret" {
    value = azuread_service_principal_password.spn_pass.value
    sensitive = true
}

output "spn_group_id" {
    value = azuread_group_member.DSCGroup.group_object_id
}