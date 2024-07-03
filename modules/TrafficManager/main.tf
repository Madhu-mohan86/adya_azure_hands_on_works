resource "azurerm_resource_group" "create_rg" {
  name = var.resource_group_name
  location = var.location
}

resource "azurerm_linux_web_app" "linux_app" {
  for_each = var.app_name
  resource_group_name = azurerm_resource_group.create_rg.name
  location = var.location
  name = each.value
  service_plan_id = azurerm_service_plan.service_plan.id
  site_config {
    application_stack {
      node_version = "20-lts"
    }
  }
}

resource "azurerm_service_plan" "service_plan" {
  resource_group_name = azurerm_resource_group.create_rg.name
  location = var.location
  name = var.resource_group_name
  os_type = "Linux"
  sku_name = "S1"
}

resource "azurerm_traffic_manager_profile" "create_traffic_manager" {
  name = "traffic-manager-01"
  resource_group_name = var.resource_group_name
  traffic_routing_method = "Priority"
  dns_config {
    relative_name = "esxedmxkmedoo2oo"
    ttl = 60
  }
  monitor_config {
    port = 80
    protocol = "HTTP"
    path = "/"
  }
}

resource "azurerm_traffic_manager_azure_endpoint" "associate_endpoint" {
   for_each = var.app_name
   name = "priority01"
   profile_id = azurerm_traffic_manager_profile.create_traffic_manager.id
   target_resource_id = azurerm_linux_web_app.linux_app["random-primary1"].id
}
