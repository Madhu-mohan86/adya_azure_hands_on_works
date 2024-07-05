# resource "azurerm_recovery_services_vault" "create_recovery_service" {
#   resource_group_name = var.rg
#   location = var.location
#   name = var.recovery_service_name
#   sku = var.sku
# }

# resource "azurerm_backup_policy_vm" "create_policy" {
#   resource_group_name = var.rg
#   recovery_vault_name = azurerm_recovery_services_vault.create_recovery_service.name
#   name = var.backup_policy
#   backup {
#     frequency = "Daily"
#     time = "23:00"
#   }

#   retention_daily {
#     count = 7
#   }

# }

# resource "azurerm_backup_protected_vm" "associate-policy" {
#   recovery_vault_name = azurerm_recovery_services_vault.create_recovery_service.name
#   resource_group_name = var.rg
#   source_vm_id = var.vm_id
#   backup_policy_id = azurerm_backup_policy_vm.create_policy.id
# }



resource "azurerm_data_protection_backup_vault" "create_backup_vault" {
  resource_group_name = var.rg
  location = var.location
  name = var.recovery_service_name
  datastore_type = "VaultStore"
  redundancy = "LocallyRedundant"
  soft_delete = "Off"
}

resource "azurerm_data_protection_backup_policy_disk" "name" {
  name = var.backup_policy
  vault_id = azurerm_data_protection_backup_vault.create_backup_vault.id
  backup_repeating_time_intervals = ["R/2021-05-19T06:33:16+00:00/PT4H"]
  default_retention_duration =  "P7D"
}

resource "azurerm_data_protection_backup_instance_disk" "name" {
  location = var.location
  name = "example-disk-backup"
  disk_id = var.disk_id
  backup_policy_id = azurerm_data_protection_backup_policy_disk.name.id
  vault_id = azurerm_data_protection_backup_vault.create_backup_vault.id
  snapshot_resource_group_name = var.rg
}

