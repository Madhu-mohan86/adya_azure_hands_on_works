resource "azurerm_resource_group" "create_rg" {
  name = var.rg_name
  location = var.location
}

resource "random_string" "generate_string" {
  length = 4
  upper = false
  lower = true
  special = false

}

resource "tls_private_key" "ssl" {
  algorithm = "RSA"
  rsa_bits  = 2048
}


resource "local_file" "store" {
  content = tls_private_key.ssl.private_key_pem
  filename = pathexpand("~/test4.pem")
}

resource "local_file" "store1" {
  content = tls_private_key.ssl.public_key_pem
  filename = pathexpand("~/test5.pem")
}
resource "local_file" "store2" {
  content = tls_private_key.ssl.public_key_fingerprint_sha256
  filename = pathexpand("~/test6.pem")
}


resource "azurerm_virtual_network" "create_vnet" {
  resource_group_name = azurerm_resource_group.create_rg.name
  location = var.location
  name = "${random_string.generate_string.result}-vnet"
  address_space = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "create_subnet" {
  resource_group_name = azurerm_resource_group.create_rg.name
  name = "${random_string.generate_string.result}-subnet"
  address_prefixes = [ "10.0.0.0/25" ]
  virtual_network_name = azurerm_virtual_network.create_vnet.name
}

resource "azurerm_linux_virtual_machine_scale_set" "create_vmss" {
  resource_group_name = azurerm_resource_group.create_rg.name
  location = var.location
  name = "${random_string.generate_string.result}-vss"
  admin_username = "admin"
  sku = "Standard_B1s"
  instances = 1
  disable_password_authentication = true
  admin_ssh_key {
    username = "admin"
    public_key = pathexpand(file("~/.ssh/id_rsa.pub"))
  }
  source_image_reference {
     publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
   network_interface {
    name    = "${random_string.generate_string.result}-nic"
    primary = true
    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.create_subnet.id
    }
  }
}



resource "azurerm_monitor_autoscale_setting" "monitor_vss" {
  resource_group_name = azurerm_resource_group.create_rg.name
  location = var.location
  name = "${random_string.generate_string.result}-monitor"
  target_resource_id = azurerm_linux_virtual_machine_scale_set.create_vmss.id
  profile {
    name = "trial"
    capacity {
      maximum = 3
      minimum = 1
      default = 1
    }
    rule {
      metric_trigger {
        metric_name = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.create_vmss.id
        time_grain = "PT1M"
        time_aggregation = "Average"
        time_window = "PT5M"
        operator = "GreaterThan"
        threshold = 40
        statistic = "Max"
      }
      scale_action {
        direction = "Increase"
        type = "ChangeCount"
        value = 1
        cooldown = "PT1M"
      }
    }
    rule {
      metric_trigger {
        metric_name = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.create_vmss.id
        time_grain = "PT1M"
        time_aggregation = "Average"
        time_window = "PT5M"
        operator = "LessThan"
        threshold = 30
        statistic = "Min"
      }
      scale_action {
        direction = "Decrease"
        type = "ChangeCount"
        value = 1
        cooldown = "PT1M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = true
      custom_emails                         = ["madhumohanmadhumohan3@gmail.com"]
    }
  }
  
}