resource "azurerm_lb" "create_load_balancer" {
  name = "load_balancer_provision_test"
  resource_group_name = var.rg
  location = var.location
  frontend_ip_configuration {
    name = "for_test"
    subnet_id = var.subnet_id
    public_ip_address_id = var.private_lb_or_public_lb ? null : azurerm_public_ip.lb_pubip.id
    private_ip_address_allocation = var.private_lb_or_public_lb ? "Dynamic" : null
  }
}

resource "azurerm_lb_backend_address_pool" "create_backend_pool" {
   name = "backend_private1"
   loadbalancer_id = azurerm_lb.create_load_balancer.id
   virtual_network_id = var.vn_id
}

# resource "azurerm_network_interface_backend_address_pool_association" "associate_backend" {
#   backend_address_pool_id = azurerm_lb_backend_address_pool.create_backend_pool.id
#   ip_configuration_name = "ipconfig"
#   network_interface_id = var.nic_id
# }

resource "azurerm_public_ip" "lb_pubip" {
  name = "lb_pubip"
  resource_group_name = var.rg
  location = var.location
  allocation_method = "Dynamic"
  lifecycle {
    create_before_destroy = true
  }
}
