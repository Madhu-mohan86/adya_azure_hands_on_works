output "rg" {
  value = var.resource_group
}

output "location" {
  value = var.location
}

output "vn_id" {
  value = data.azurerm_virtual_network.vnet_list.id
}

output "nic_id" {
  value = values(azurerm_network_interface.vm01_n_private)[*].id
}
