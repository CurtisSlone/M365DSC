
resource "time_rotating" "main" {
  rotation_rfc3339 = var.service_principal_password_end_date
  rotation_years   = var.service_principal_password_rotation_in_years
  rotation_days    = var.service_principal_password_rotation_in_days

  triggers = {
    end_date = var.service_principal_password_end_date
    years    = var.service_principal_password_rotation_in_years
    days     = var.service_principal_password_rotation_in_days
  }
}

resource "azuread_service_principal_password" "sp_password" {
  count                = var.enable_service_principal_certificate == false ? 1 : 0
  service_principal_id = azuread_service_principal.sp.object_id
  rotate_when_changed = {
    rotation = time_rotating.main.id
  }
}