resource "azurerm_virtual_machine" "vm_01" {

   lifecycle {
     ignore_changes = [ identity ]
   }

  for_each = var.vm_name
  resource_group_name = var.resource_group
  name = each.value
  location = var.location
  vm_size = var.vm_size
  delete_os_disk_on_termination = true
 
  storage_os_disk {
    name = "${each.value}_storagedisk"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  network_interface_ids = var.private_or_public ? [ azurerm_network_interface.vm01_n_private[each.key].id ] : [ azurerm_network_interface.vm01_n_public[each.key].id ]
  storage_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version = "latest"
  }
  os_profile {
    computer_name = "tfcomputer"
    admin_username = "azureuser"
    custom_data = cloudinit_config.generate_configs.rendered

# base64encode(<<CLOUD_INIT
# #cloud-config
# runcmd:
#   - wget -q -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
#   - echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
#   - sudo apt-get update
#   - sudo apt-get install -y default-jre
#   - sudo apt-get install -y jenkins
# CLOUD_INIT
# )


}

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/azureuser/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }
}

resource "azurerm_subnet" "vm01_subnet" {
  for_each = zipmap(
    var.vm_name_and_address["vm_name"],
    var.vm_name_and_address["vm_address_prefixes"]
  )
  
  resource_group_name = var.resource_group
  name = "${each.key}_subnet"
  virtual_network_name = data.azurerm_virtual_network.vnet_list.name
  address_prefixes = [each.value]
}



resource "azurerm_network_interface" "vm01_n_private" {
  for_each = var.vm_name
  resource_group_name = var.resource_group
  location = var.location
  name = "${each.value}_private_networkinterface"
  ip_configuration {
    name = "ipconfig"
    subnet_id = azurerm_subnet.vm01_subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "vm01_n_public" {
  for_each = var.vm_name
  resource_group_name = var.resource_group
  location = var.location
  name = "${each.value}_public_networkinterface"
  ip_configuration {
    name = "ipconfig"
    subnet_id = azurerm_subnet.vm01_subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vm01_pubip[each.key].id
  }
}

resource "azurerm_public_ip" "vm01_pubip" {
  for_each = var.vm_name
  name = "${each.value}_pubip"
  resource_group_name = var.resource_group
  location = var.location
  allocation_method = "Dynamic"
  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_network_security_group" "nsg_def" {
  for_each = var.vm_name
  name = "${each.value}_nsg"
  resource_group_name = var.resource_group
  location = var.location
  security_rule {
    name = "Http"
    priority = 110
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range = 80
    destination_port_range = 80
    source_address_prefix = "*"
    destination_address_prefix = "*"

  }
}

resource "azurerm_network_security_rule" "ssh" {
    for_each = var.vm_name
    name="AllowAnySSHInbound"
    direction="Inbound"
    priority = 100
    access="Allow"
    protocol="*"
    source_port_range=22
    destination_port_range=22
    source_address_prefix="*"
    destination_address_prefix="*"
    network_security_group_name = azurerm_network_security_group.nsg_def[each.key].name
    resource_group_name = var.resource_group
}

resource "azurerm_network_security_rule" "jenkinsinbound" {
    for_each = var.vm_name
    name="Jenkinsinboundport"
    direction="Inbound"
    priority = 120
    access="Allow"
    protocol="*"
    source_port_range=8080
    destination_port_range=8080
    source_address_prefix="*"
    destination_address_prefix="*"
    network_security_group_name = azurerm_network_security_group.nsg_def[each.key].name
    resource_group_name = var.resource_group
}


resource "azurerm_network_security_rule" "jenkinsoutbound" {
    for_each = var.vm_name
    name="Jenkinsoutboundport"
    direction="Outbound"
    priority = 130
    access="Allow"
    protocol="*"
    source_port_range=8080
    destination_port_range=8080
    source_address_prefix="*"
    destination_address_prefix="*"
    network_security_group_name = azurerm_network_security_group.nsg_def[each.key].name
    resource_group_name = var.resource_group
}


resource "azurerm_network_interface_security_group_association" "nsg_asste" {
  for_each = toset(var.vm_name_and_address["vm_name"])
  network_interface_id = var.private_or_public ? azurerm_network_interface.vm01_n_private[each.key].id : azurerm_network_interface.vm01_n_public[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg_def[each.key].id
}


resource "cloudinit_config" "generate_configs" {
  base64_encode = true
  gzip = true

  part {
    filename = "cloudinit-jenkins.yaml"
    content_type = "text/cloud-config"
    content = file("${path.module}/cloudinit-jenkins.yaml")
  }
}