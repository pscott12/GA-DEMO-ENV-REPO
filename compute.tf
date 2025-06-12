resource "azurerm_resource_group" "linuxvm" {
  # This resource group is for the linuxvm 
  name     = "rg-${var.application_name_three}-${var.enviroment_name}"
  location = var.primary_location
}

resource "azurerm_public_ip" "vm1" {
  name                = "pip-${var.application_name_three}-${var.enviroment_name}-vm1"
  resource_group_name = azurerm_resource_group.linuxvm.name
  location            = azurerm_resource_group.linuxvm.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vm1" {
  name                = "nic-${var.application_name_three}-${var.enviroment_name}-vm1"
  location            = azurerm_resource_group.linuxvm.location
  resource_group_name = azurerm_resource_group.linuxvm.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.alpha.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm1.id
  }
}
# RSA key of size 4096 bits
resource "tls_private_key" "vm1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Linux VM
resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "vm1${var.application_name_three}${var.enviroment_name}"
  resource_group_name = azurerm_resource_group.linuxvm.name
  location            = azurerm_resource_group.linuxvm.location
  size                = "Standard_D2_v2_Promo"
  admin_username      = "pscott"
  network_interface_ids = [
    azurerm_network_interface.vm1.id,
  ]

  admin_ssh_key {
    username   = "admin"
    public_key = tls_private_key.vm1.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
