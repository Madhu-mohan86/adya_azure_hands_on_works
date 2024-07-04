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


output "vm_id" {
  value = [for vm in azurerm_virtual_machine.vm_01 : vm.id]
}

output "subnet_id" {
  value = [for sn in azurerm_subnet.vm01_subnet : sn.id]
}