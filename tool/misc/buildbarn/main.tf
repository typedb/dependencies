provider "azurerm" {
  features {}
  skip_provider_registration = true
  version                    = "~> 2.9"
}

resource "azurerm_virtual_network" "network" {
  name                = "network"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = "buildbarn"
}

resource "azurerm_subnet" "buildbarn_subnet" {
  name                 = "internal"
  resource_group_name  = "buildbarn"
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_public_ip" "public_ip" {
  name                = "buildbarn-public-ip"
  location            = "eastus"
  resource_group_name = "buildbarn"
  allocation_method   = "Static"
}



resource "azurerm_network_interface" "buildbarn-nic" {

  name                = "buildbarn-nic"
  location            = "eastus"
  resource_group_name = "buildbarn"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.buildbarn_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "buildbarn" {
  name                = "buildbarn"
  resource_group_name = "buildbarn"
  location            = "eastus"
  size                = "Standard_F8"
  admin_username      = "buildbarn"
  network_interface_ids = [
    azurerm_network_interface.buildbarn-nic.id,
  ]


  admin_ssh_key {
    username   = "buildbarn"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRWFmUPEjgoX2mBP73hX5l22gR2rIN6BBuqpErjANw6gajptYbxhy9OK4JBqiGMir6gfWiihPgkysKrfxDfS6skT1ULayKiZmabcTKB2UJ0shseB3triD/10LVZzTAQaRdKpuzj/zjNhOjH/u2rNu+mRHL8cZ/Fmj+Fow8baqtyVebnmdP05JjL+mE6pbSvz1s0BXFA8RTNk1tJY9E9z403nucSsK0d9KK5cyzpvdozZG4y4faNr36O5q2rKSvudjYkANirn97oU6orc77lFjOUTob7qrxWPrj1XsOhOt3Ac2C8cPiUzgeuusPhLuSHmRcqYjKfTRYB4klSn/AqQ6S9Y95T4M/eTvqDsuIw5r7SgrSWAMsewkAkZOs4All5dtt2dLc3Fa7PtRR0+hSPB6OlyvEwVyQcQqNmW/eOt7l9KgqjCvHEZmBflug9LM5UK7zMf04+6qaHrkXIOi9M/EyVz7Hjg9/sQkq61V9wE821Aksm1coqRwAOmi3xH9c7Gu1tEdMCE7ZqJ0EzkF9wARR+jtJp3c1sWxn7wE+TJTgrJLBdIVd5QRdpmCq9hFgnE7SwqKklvQtNzGh3rEOBBWNxulJ7uqfcE5Qn4L+GcGiJJqXUwJvJyOSHYApI1crvwYzpbos/PwQNRmDAtFzCGdR44Ahesam5nwjP/mrGuXxzQ=="
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "buildbarn-disk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(file("./setup-buildbarn.sh"))
}
