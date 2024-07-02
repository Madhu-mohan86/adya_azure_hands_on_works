resource "azurerm_role_assignment" "user_role_assign" {
   scope = var.resource_group
   principal_id = var.principal_id
   role_definition_name = "Virtual Machine Contributor"
}