resource "azurerm_resource_group" "lab" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "lab" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
}

resource "azurerm_subnet" "public" {
  name                 = var.public_subnet_name
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = var.public_subnet_prefixes
}

resource "azurerm_subnet" "private" {
  name                 = var.private_subnet_name
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = var.private_subnet_prefixes
}

resource "azurerm_network_security_group" "kali" {
  name                = "kali-nsg"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  security_rule {
    name                       = "Allow-SSH-Admin"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.allowed_admin_cidr
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "target" {
  name                = "target-nsg"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  security_rule {
    name                       = "Allow-From-Lab"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = azurerm_subnet.public.address_prefixes[0]
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.kali.id
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.target.id
}

resource "azurerm_public_ip" "kali" {
  name                = "kali-pip"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "kali" {
  name                = "kali-nic"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "kali-ipconfig"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.kali.id
  }
}

resource "azurerm_network_interface" "target" {
  name                = "target-nic"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "target-ipconfig"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "kali" {
  name                = var.kali_vm_name
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  size                = var.kali_vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.kali.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  disable_password_authentication = true

  source_image_reference {
    publisher = var.kali_image_publisher
    offer     = var.kali_image_offer
    sku       = var.kali_image_sku
    version   = var.kali_image_version
  }

  plan {
    name      = var.kali_image_sku
    product   = var.kali_image_offer
    publisher = var.kali_image_publisher
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
}

resource "azurerm_linux_virtual_machine" "target" {
  name                = var.target_vm_name
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  size                = var.target_vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.target.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  disable_password_authentication = true

  source_image_reference {
    publisher = var.target_image_publisher
    offer     = var.target_image_offer
    sku       = var.target_image_sku
    version   = var.target_image_version
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
}
