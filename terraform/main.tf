resource "azurerm_resource_group" "rg" {
  for_each = var.regions
  name     = "datetime-${each.key}-rg"
  location = each.value
}

resource "azurerm_virtual_network" "vnet" {
  for_each            = var.regions
  name                = "vnet-${each.key}"
  location            = each.value
  resource_group_name = azurerm_resource_group.rg[each.key].name
  address_space       = ["10.${index(keys(var.regions), each.key)}.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.regions
  name                 = "subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.rg[each.key].name
  virtual_network_name = azurerm_virtual_network.vnet[each.key].name
  address_prefixes     = ["10.${index(keys(var.regions), each.key)}.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.regions
  name                = "nic-${each.key}"
  location            = each.value
  resource_group_name = azurerm_resource_group.rg[each.key].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each              = var.regions
  name                  = "datetime-${each.key}-vm"
  location              = each.value
  resource_group_name   = azurerm_resource_group.rg[each.key].name
  size                  = var.vm_size
  admin_username        = var.admin_user
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  admin_ssh_key {
    username   = var.admin_user
    public_key = file("~/.ssh/id_rsa.pub")
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

