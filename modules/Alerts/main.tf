resource "azurerm_resource_group" "creat_resource_group" {
  name = "for-alerts"
  location = "West US"
}



resource "azurerm_monitor_action_group" "create_mg" {
  resource_group_name = azurerm_resource_group.creat_resource_group.name
  name = "montr-grp-vmss"
  short_name = "mvg"

  email_receiver {
    name = "madhumohan"
    email_address = var.email
    use_common_alert_schema = true
  }

}


resource "azurerm_monitor_metric_alert" "name" {

    resource_group_name = azurerm_resource_group.creat_resource_group.name
    name = "cpu-metric-alert"
    scopes = [ data.azurerm_virtual_machine_scale_set.fetch_virtual_machine_details.id ]
    description = "this is the notification rule for cpu usage"

    criteria {
      metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
      metric_name = "Percentage CPU"
      aggregation = "Maximum"
      threshold = 40
      operator = "GreaterThan"
    }
  
}