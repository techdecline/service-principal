output "sp_object_id" {
  value = azuread_service_principal.sp.object_id
}

output "sp_client_id" {
  value = azuread_application.sp.application_id
}

output "sp_display_name" {
  value = azuread_application.sp.display_name 
}

output "sp_password" {
  value = azuread_service_principal_password.sp.value
  sensitive = true
}