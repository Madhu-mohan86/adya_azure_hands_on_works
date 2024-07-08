resource "random_string" "storage_account_name" {
  length  = 8
  lower   = true
  numeric = false
  special = false
  upper   = false
}


resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "fortfblobs"
}

# Generate random value for the storage account name
resource "azurerm_storage_account" "storage_account" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  name = random_string.storage_account_name.result

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

}
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

resource "azurerm_storage_blob" "example" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = var.path
}


# data "azurerm_storage_account_sas" "generate_token" {
#   resource_types {
#     service = false
#     container = true
#     object = false
#   }
#   connection_string = azurerm_storage_account.storage_account.primary_connection_string
#   permissions {
#     read = true
#     list = true
#     add = false
#     tag = false
#     start = false
#     expiry
#   }
# }


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
