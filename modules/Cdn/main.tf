resource "azurerm_resource_group" "create_resource_group" {
  name = var.resource_group_name
  location = var.location
}

resource "azurerm_cdn_profile" "create_cdn_profile" {
  resource_group_name = azurerm_resource_group.create_resource_group.id
  location = azurerm_resource_group.create_resource_group.location
  name = var.cdn_profile_name
  sku = "Standard_Microsoft"
}
