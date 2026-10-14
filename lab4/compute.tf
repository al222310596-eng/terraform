# ============================================
# Azure Bastion - Public IP
# ============================================
resource "azurerm_public_ip" "bastion_pip" {
  name                = "pip-bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# ============================================
# Azure Bastion Host
# ============================================
resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-lz"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}

# ============================================
# VM Linux Worker - Network Interface
# ============================================
resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-vm-worker"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet_vm.id
    private_ip_address_allocation = "Dynamic"
  }
}

# ============================================
# VM Linux Worker
# ============================================
resource "azurerm_linux_virtual_machine" "vm_worker" {
  name                              = "vm-worker"
  resource_group_name               = azurerm_resource_group.rg.name
  location                          = azurerm_resource_group.rg.location
  size                              = "Standard_B2ats_v2"
  admin_username                    = "azureuser"
  disable_password_authentication   = true
  vm_agent_platform_updates_enabled = true

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("C:/Users/hugoe/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}