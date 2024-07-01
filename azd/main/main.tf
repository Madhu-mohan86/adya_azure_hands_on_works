
module "users" {
  source = "../modules/users"
}


module "group" {
  source = "../modules/groups"
}

data "azurerm_resource_group" "resource_group" {
  name = "intro_group"
}


module "roles" {
  source = "../modules/roles"
  principal_id = module.group.group_id
  resource_group = data.azurerm_resource_group.resource_group.id
}