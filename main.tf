resource "azuread_application" "sp" {
  display_name = var.sp_name
  # required_resource_access {
  #   resource_app_id = "00000003-0000-0000-c000-000000000000"
  #   resource_access {
  #     id   = "06da0dbc-49e2-44d2-8312-53f166ab848a"
  #     type = "Scope"
  #   }
  #   resource_access {
  #     id   = "5f8c59db-677d-491f-a6b8-5f174b11ec1d"
  #     type = "Scope"
  #   }
  # }
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