resource "azuread_application" "sp" {
  display_name = var.sp_name
  dynamic "required_resource_access" {
    for_each = var.required_resource_access
    content {
      resource_app_id = required_resource_access.value["resource_app_id"]
      dynamic "resource_access" {
        for_each = required_resource_access.value["resource_access"]
        content {
          id = resource_access.value["id"]
          type = resource_access.value["type"]
        }
      }
    }
  }
}

resource "azuread_service_principal" "sp" {
  application_id = azuread_application.sp.application_id
}

resource "azuread_service_principal_password" "sp" {
  service_principal_id = azuread_service_principal.sp.id
}

resource "azurerm_role_assignment" "sp" {
  scope                = var.scope
  role_definition_name = var.built_in_role
  principal_id         = azuread_service_principal.sp.object_id
}

resource "azurerm_key_vault_secret" "sp" {
  count        = length(var.key_vault_id) > 0 ? 1 : 0
  name         = azuread_application.sp.display_name
  value        = azuread_service_principal_password.sp.value
  key_vault_id = var.key_vault_id
}