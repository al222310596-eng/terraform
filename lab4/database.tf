# ============================================
# Contraseña aleatoria para admin de PostgreSQL
# ============================================
resource "random_password" "pg_password" {
  length      = 20
  special     = true
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
}

# ============================================
# Sufijo aleatorio para nombre único global
# ============================================
resource "random_string" "pg_suffix" {
  length  = 5
  special = false
  upper   = false
  numeric = true
}

# ============================================
# PostgreSQL Flexible Server
# ============================================
resource "azurerm_postgresql_flexible_server" "pg" {
  name                   = "pg-lz-${random_string.pg_suffix.result}"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "15"
  administrator_login    = "pgadmin"
  administrator_password = random_password.pg_password.result
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  zone                   = "2"

  delegated_subnet_id = azurerm_subnet.snet_db.id
  private_dns_zone_id = azurerm_private_dns_zone.postgres.id

  public_network_access_enabled = false

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.postgres_link
  ]
}

# ============================================
# Base de datos inicial
# ============================================
resource "azurerm_postgresql_flexible_server_database" "appdb" {
  name      = "appdb"
  server_id = azurerm_postgresql_flexible_server.pg.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# ============================================
# RBAC: Managed Identity de App Service -> PostgreSQL
# ============================================
resource "azurerm_role_assignment" "app_to_pg" {
  scope                = azurerm_postgresql_flexible_server.pg.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_linux_web_app.app.identity[0].principal_id
}