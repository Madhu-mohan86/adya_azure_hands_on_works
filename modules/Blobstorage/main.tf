
resource "random_string" "name" {
  length = 5
  special = false
  lower = true
  upper = false
}

resource "azurerm_resource_group" "create_resource_group" {
  name = "fortfblobs"
  location = "West US"
}

resource "azurerm_storage_account" "create_storage_account" {
  resource_group_name = azurerm_resource_group.create_resource_group.name
  location = azurerm_resource_group.create_resource_group.location
  name = "${azurerm_resource_group.create_resource_group.name}strgeaccnt"
  account_tier = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"

  static_website {
    index_document = "index.html"
  }
}

resource "azurerm_storage_container" "create_container" {
  name = "${random_string.name.id}-container"
  storage_account_name = azurerm_storage_account.create_storage_account.name
}


resource "azurerm_storage_blob" "create_blob" {
  storage_account_name = azurerm_storage_account.create_storage_account.name
  storage_container_name = "$web"
  name = "${random_string.name.id}-blob"
  type = "Block"
  content_type = "text/html"
  source = pathexpand("~/index.html")
}

resource "local_file" "foo" {
  content  = azurerm_storage_account.create_storage_account.primary_blob_endpoint
  filename = "/home/madhu/path1.txt"
}
