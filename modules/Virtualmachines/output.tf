output "rg" {
  value = var.resource_group
}

output "location" {
  value = var.location
}

output "vn_id" {
  value = data.azurerm_virtual_network.vnet_list.id
}