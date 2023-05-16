# AzureAD Directory Role assignment based on the roles template_ids provided in the directory roles variable

resource "azuread_directory_role_assignment" "dir_role_assignment" {
    depends_on = [ 
        azuread_service_principal.sp
     ]
    count = length(var.service_principal_directory_roles)
    role_id = var.service_principal_directory_roles[count.index]
    principal_object_id = azuread_service_principal.sp.object_id
}