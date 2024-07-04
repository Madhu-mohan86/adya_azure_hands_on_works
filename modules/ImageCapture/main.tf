resource "azurerm_image" "create_image" {
  resource_group_name = var.resource_group_name
  location = var.location
  name = "image-capture-check"
  source_virtual_machine_id = var.vm_id
  os_disk {
    os_type = "Linux"
  }
}