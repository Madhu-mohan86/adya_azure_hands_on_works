resource "azurerm_image" "name" {
  resource_group_name = var.resource_group
  location = var.location
  name = "image_from_vm"
  source_virtual_machine_id = var.source_virtual_machine_id

  os_disk {
    os_type = "Linux"
  }
}