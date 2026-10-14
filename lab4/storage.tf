# ============================================
# Sufijo aleatorio para nombre único global
# ============================================
resource "random_string" "storage_suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}

# ============================================
# Storage Account para Blob
# ============================================
resource "azurerm_storage_account" "blob" {
  name                            = "stlzprod${random_string.storage_suffix.result}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false

  blob_properties {
    versioning_enabled = true
  }
}

# ============================================
# Private Endpoint de Blob (en snet-endpoints)
# ============================================
resource "azurerm_private_endpoint" "blob" {
  name                = "pe-blob"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.snet_endpoints.id

  private_service_connection {
    name                           = "psc-blob"
    private_connection_resource_id = azurerm_storage_account.blob.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "dns-group-blob"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }
}

# ============================================
# RBAC: Managed Identity de App Service -> Blob Storage
# ============================================
resource "azurerm_role_assignment" "app_to_blob" {
  scope                = azurerm_storage_account.blob.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_web_app.app.identity[0].principal_id
}