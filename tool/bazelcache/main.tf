provider "azurerm" {
  features {}
  skip_provider_registration = true
  version = "~> 2.9"
}


terraform {
  backend "azurerm" {
    resource_group_name = "grabl-common"
    storage_account_name = "graknlabsgrabl"
    container_name = "bazel-cache-state"
    key = "terraform.tfstate"
  }
}

resource "azurerm_linux_virtual_machine" "bazel_cache" {
  name = "bazel-cache"
  resource_group_name = "grabl-prod"
  location = "uksouth"
  size = "Standard_F8s_v2"
  admin_username = "bazel"
  network_interface_ids = [
    azurerm_network_interface.bazel_nic.id,
  ]
  disable_password_authentication = false

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Premium_LRS"
    name = "bazel-cache_OsDisk_1_c02f51bc56c24105a39b64c5cf7b0bbb"
    disk_size_gb = 100
  }

  source_image_reference {
    offer = "0001-com-ubuntu-server-groovy"
    publisher = "canonical"
    sku = "20_10"
    version = "latest"
  }

}

resource "azurerm_network_interface" "bazel_nic" {
  name = "bazel-cache464"
  location = "uksouth"
  resource_group_name = "grabl-prod"
  enable_accelerated_networking = true

  ip_configuration {
    name = "ipconfig1"
    subnet_id = "/subscriptions/6141eaee-1024-4122-8132-870565af3c0d/resourceGroups/grabl-prod/providers/Microsoft.Network/virtualNetworks/network/subnets/internal"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.bazel_cache_public_ip.id
  }
}

resource "azurerm_public_ip" "bazel_cache_public_ip" {
  name = "bazel-cache-ip"
  location = "uksouth"
  resource_group_name = "grabl-prod"
  allocation_method = "Dynamic"
}

