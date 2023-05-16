resource "azuread_service_principal" "PnPShell" {
  application_id = "31359c7f-bd7e-475c-86db-fdb8c937548e"
  use_existing = true
}