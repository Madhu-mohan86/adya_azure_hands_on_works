resource "azurerm_managed_disk" "create_disk" {
  resource_group_name = var.resource_group
  location = var.location
  name = "tfmanageddisk"
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb = 30
}

# resource "azurerm_virtual_machine_data_disk_attachment" "name" {
#   managed_disk_id = azurerm_managed_disk.create_disk.id
#   virtual_machine_id = var.az_vmid
#   caching = "ReadWrite"
#   lun = "10"
# }

