resource "azurerm_recovery_services_vault" "create_recovery_service" {
  resource_group_name = var.rg
  location = var.location
  name = var.recovery_service_name
  sku = var.sku
}

resource "azurerm_backup_policy_vm" "create_policy" {
  resource_group_name = var.rg
  recovery_vault_name = azurerm_recovery_services_vault.create_recovery_service.name
  name = var.backup_policy
  backup {
    frequency = "Daily"
    time = "23:00"
  }

  retention_daily {
    count = 7
  }

}

resource "azurerm_backup_protected_vm" "associate-policy" {
  recovery_vault_name = azurerm_recovery_services_vault.create_recovery_service.name
  resource_group_name = var.rg
  source_vm_id = var.vm_id
  backup_policy_id = azurerm_backup_policy_vm.create_policy.id
}

