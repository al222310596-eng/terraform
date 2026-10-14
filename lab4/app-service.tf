# ============================================
# Sufijo aleatorio para nombre único global
# ============================================
resource "random_string" "app_suffix" {
  length  = 5
  special = false
  upper   = false
  numeric = true
}

# ============================================
# App Service Plan (Linux, SKU B1)
# ============================================
resource "azurerm_service_plan" "asp" {
  name                = "asp-lz-prod"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# ============================================
# App Service Linux con Managed Identity
# + VNet Integration integrada en el atributo
# ============================================
resource "azurerm_linux_web_app" "app" {
  name                      = "app-lz-${random_string.app_suffix.result}"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_service_plan.asp.location
  service_plan_id           = azurerm_service_plan.asp.id
  virtual_network_subnet_id = azurerm_subnet.snet_app.id

  site_config {
    always_on = true

    application_stack {
      node_version = "18-lts"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }
}