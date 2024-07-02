resource "azuread_group" "create_group" {
  display_name = var.group_name
  description = "test group for experimenting iam"
  mail_enabled = false
  security_enabled = true
}


data "azuread_users" "users" {
   return_all = true
}

resource "azuread_group_member" "add_users" {
    group_object_id = azuread_group.create_group.id
    for_each = toset(data.azuread_users.users.object_ids)
    member_object_id = each.value
}
