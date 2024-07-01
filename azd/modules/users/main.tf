data "azuread_domains" "domain" {
  only_initial = true
}

resource "azuread_user" "create_user" {

  for_each = local.names
  display_name = each.key
  user_principal_name = "${each.key}@${data.azuread_domains.domain.domains.0.domain_name}"
  password = "#${var.names}86"

}

locals {
  names=toset(split(",",(file("~/names.csv"))))
}