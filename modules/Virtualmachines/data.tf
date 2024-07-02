# data "azurerm_virtual_machine" "vm_list" {
#   resource_group_name = "intro_group"
#   for_each = local.instance_list
#   name = each.value
# }


data "azurerm_virtual_network" "vnet_list" {
  resource_group_name = var.resource_group
  name = "intro-vnet"
}

# locals{
#     instance_list= toset(jsondecode(file("~/vmlist.txt")))
# }

# resource "terraform_data" "example" {
#   provisioner "local-exec" {
#     command = <<-EOT
#       export VM_LIST="$(az vm list --resource-group intro_group --query '[].name')"
#     EOT
#   }
# }

