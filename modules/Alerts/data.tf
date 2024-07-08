data "azurerm_virtual_machine_scale_set" "fetch_virtual_machine_details" {
  resource_group_name = "MC_rg-aks-iam_cluster_for_iam_southindia"
  name = "aks-aksnode1-18862781-vmss"
}