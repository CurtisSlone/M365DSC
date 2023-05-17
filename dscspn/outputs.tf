# AAD
output "AAD_service_principal_name" {
  description = "The name of the service principal"
  value       = module.dsc_aad_spn.service_principal_name
}

output "AAD_service_principal_object_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = module.dsc_aad_spn.service_principal_object_id
}

output "AAD_service_principal_application_id" {
  description = "The application id of service principal"
  value       = module.dsc_aad_spn.service_principal_application_id
}

output "AAD_client_id" {
  description = "The application id of AzureAD application created."
  value       = module.dsc_aad_spn.client_id
}

output "AAD_client_secret" {
  description = "Password for service principal."
  value       = module.dsc_aad_spn.client_secret
  sensitive   = true
}

output "AAD_service_principal_password" {
  description = "Password for service principal."
  value       = module.dsc_aad_spn.service_principal_password
  sensitive   = true
}

# Exchange
output "Exchange_service_principal_name" {
  description = "The name of the service principal"
  value       = module.dsc_exchange_spn.service_principal_name
}

output "Exchange_service_principal_object_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = module.dsc_exchange_spn.service_principal_object_id
}

output "Exchange_service_principal_application_id" {
  description = "The application id of service principal"
  value       = module.dsc_exchange_spn.service_principal_application_id
}

output "Exchange_client_id" {
  description = "The application id of AzureAD application created."
  value       = module.dsc_exchange_spn.client_id
}

output "Exchange_client_secret" {
  description = "Password for service principal."
  value       = module.dsc_exchange_spn.client_secret
  sensitive   = true
}

output "Exchange_service_principal_password" {
  description = "Password for service principal."
  value       = module.dsc_exchange_spn.service_principal_password
  sensitive   = true
}

# O365
output "O365_service_principal_name" {
  description = "The name of the service principal"
  value       = module.dsc_o365_spn.service_principal_name
}

output "O365_service_principal_object_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = module.dsc_o365_spn.service_principal_object_id
}

output "O365_service_principal_application_id" {
  description = "The application id of service principal"
  value       = module.dsc_o365_spn.service_principal_application_id
}

output "O365_client_id" {
  description = "The application id of AzureAD application created."
  value       = module.dsc_o365_spn.client_id
}

output "O365_client_secret" {
  description = "Password for service principal."
  value       = module.dsc_o365_spn.client_secret
  sensitive   = true
}

output "O365_service_principal_password" {
  description = "Password for service principal."
  value       = module.dsc_o365_spn.service_principal_password
  sensitive   = true
}

# OD
output "OD_service_principal_name" {
  description = "The name of the service principal"
  value       = module.dsc_OD_spn.service_principal_name
}

output "OD_service_principal_object_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = module.dsc_OD_spn.service_principal_object_id
}

output "OD_service_principal_application_id" {
  description = "The application id of service principal"
  value       = module.dsc_OD_spn.service_principal_application_id
}

output "OD_client_id" {
  description = "The application id of AzureAD application created."
  value       = module.dsc_OD_spn.client_id
}

output "OD_client_secret" {
  description = "Password for service principal."
  value       = module.dsc_OD_spn.client_secret
  sensitive   = true
}

output "OD_service_principal_password" {
  description = "Password for service principal."
  value       = module.dsc_OD_spn.service_principal_password
  sensitive   = true
}

# Planner
output "Planner_service_principal_name" {
  description = "The name of the service principal"
  value       = module.dsc_planner_spn.service_principal_name
}

output "Planner_service_principal_object_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = module.dsc_planner_spn.service_principal_object_id
}

output "Planner_service_principal_application_id" {
  description = "The application id of service principal"
  value       = module.dsc_planner_spn.service_principal_application_id
}

output "Planner_client_id" {
  description = "The application id of AzureAD application created."
  value       = module.dsc_planner_spn.client_id
}

output "Planner_client_secret" {
  description = "Password for service principal."
  value       = module.dsc_planner_spn.client_secret
  sensitive   = true
}

output "Planner_service_principal_password" {
  description = "Password for service principal."
  value       = module.dsc_planner_spn.service_principal_password
  sensitive   = true
}

#Power Platform
output "Power_Platform_service_principal_name" {
  description = "The name of the service principal"
  value       = module.dsc_powerplatform_spn.service_principal_name
}

output "Power_Platform_service_principal_object_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = module.dsc_powerplatform_spn.service_principal_object_id
}

output "Power_Platform_service_principal_application_id" {
  description = "The application id of service principal"
  value       = module.dsc_powerplatform_spn.service_principal_application_id
}

output "Power_Platform_client_id" {
  description = "The application id of AzureAD application created."
  value       = module.dsc_powerplatform_spn.client_id
}

output "Power_Platform_client_secret" {
  description = "Password for service principal."
  value       = module.dsc_powerplatform_spn.client_secret
  sensitive   = true
}

output "Power_Platform_service_principal_password" {
  description = "Password for service principal."
  value       = module.dsc_powerplatform_spn.service_principal_password
  sensitive   = true
}

# Security & Compliance
output "Security_Compliance_service_principal_name" {
  description = "The name of the service principal"
  value       = module.dsc_security_compliance_spn.service_principal_name
}

output "Security_Compliance_service_principal_object_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = module.dsc_security_compliance_spn.service_principal_object_id
}

output "Security_Compliance_service_principal_application_id" {
  description = "The application id of service principal"
  value       = module.dsc_security_compliance_spn.service_principal_application_id
}

output "Security_Compliance_client_id" {
  description = "The application id of AzureAD application created."
  value       = module.dsc_security_compliance_spn.client_id
}

output "Security_Compliance_client_secret" {
  description = "Password for service principal."
  value       = module.dsc_security_compliance_spn.client_secret
  sensitive   = true
}

output "Security_Compliance_service_principal_password" {
  description = "Password for service principal."
  value       = module.dsc_security_compliance_spn.service_principal_password
  sensitive   = true
}

# Teams
output "Teams_service_principal_name" {
  description = "The name of the service principal"
  value       = module.dsc_teams_spn.service_principal_name
}

output "Teams_service_principal_object_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = module.dsc_teams_spn.service_principal_object_id
}

output "Teams_service_principal_application_id" {
  description = "The application id of service principal"
  value       = module.dsc_teams_spn.service_principal_application_id
}

output "Teams_client_id" {
  description = "The application id of AzureAD application created."
  value       = module.dsc_teams_spn.client_id
}

output "Teams_client_secret" {
  description = "Password for service principal."
  value       = module.dsc_teams_spn.client_secret
  sensitive   = true
}

output "Teams_service_principal_password" {
  description = "Password for service principal."
  value       = module.dsc_teams_spn.service_principal_password
  sensitive   = true
}

# Sharepoint
output "Sharepoint_service_principal_name" {
  description = "The name of the service principal"
  value       = module.dsc_sharepoint_spn.service_principal_name
}

output "Sharepoint_service_principal_object_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = module.dsc_sharepoint_spn.service_principal_object_id
}

output "Sharepoint_service_principal_application_id" {
  description = "The application id of service principal"
  value       = module.dsc_sharepoint_spn.service_principal_application_id
}

output "Sharepoint_client_id" {
  description = "The application id of AzureAD application created."
  value       = module.dsc_sharepoint_spn.client_id
}

output "Sharepoint_client_secret" {
  description = "Password for service principal."
  value       = module.dsc_sharepoint_spn.client_secret
  sensitive   = true
}

output "Sharepoint_service_principal_password" {
  description = "Password for service principal."
  value       = module.dsc_sharepoint_spn.service_principal_password
  sensitive   = true
}