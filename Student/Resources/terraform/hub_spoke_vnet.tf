#######################################################################
## Define Locals
#######################################################################

locals {
## shared key for S2S Connection
  shared-key = "Msft123Msft123"
}

#######################################################################
## Create Virtual Networks
#######################################################################

resource "azurerm_virtual_network" "eastus2-hub-vnet" {
  name                = "eastus2-hub-vnet"
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name
  address_space       = ["10.100.0.0/16"]

  tags = {
    environment = "microhack"
    deployment  = "terraform"
    microhack   = "Firewall and Firewall Manager"
  }
}
resource "azurerm_virtual_network" "brazilsouth-hub-vnet" {
  name                = "brazilsouth-hub-vnet"
  location            = "brazilsouth"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name
  address_space       = ["10.200.0.0/16"]

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_virtual_network" "eastus2-spoke1-vnet" {
  name                = "eastus2-spoke1-vnet"
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name
  address_space       = ["10.10.1.0/24"]

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_virtual_network" "brazilsouth-spoke1-vnet" {
  name                = "brazilsouth-spoke1-vnet"
  location            = "brazilsouth"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name
  address_space       = ["10.20.1.0/24"]

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_virtual_network" "brazilsouth-spoke2-vnet" {
  name                = "brazilsouth-spoke2-vnet"
  location            = "brazilsouth"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name
  address_space       = ["10.20.2.0/24"]

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}

#######################################################################
## Create Subnets
#######################################################################

resource "azurerm_subnet" "eastus2-hub-GatewaySubnet-vnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name = azurerm_virtual_network.eastus2-hub-vnet.name
  address_prefix       = "10.100.1.0/27"
}
resource "azurerm_subnet" "brazilsouth-hub-GatewaySubnet-vnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name = azurerm_virtual_network.brazilsouth-hub-vnet.name
  address_prefix       = "10.200.1.0/27"
}
resource "azurerm_subnet" "eastus2-hub-bastion-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name = azurerm_virtual_network.eastus2-hub-vnet.name
  address_prefix       = "10.100.2.0/27"
}
resource "azurerm_subnet" "brazilsouth-hub-bastion-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name = azurerm_virtual_network.brazilsouth-hub-vnet.name
  address_prefix       = "10.200.2.0/27"
}

resource "azurerm_subnet" "eastus2-hub-firewall-subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name = azurerm_virtual_network.eastus2-hub-vnet.name
  address_prefix       = "10.100.3.0/26"
}
resource "azurerm_subnet" "brazilsouth-hub-firewall-subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name = azurerm_virtual_network.brazilsouth-hub-vnet.name
  address_prefix       = "10.200.3.0/26"
}

resource "azurerm_subnet" "eastus2-spoke1-vm-subnet" {
  name                 = "vmsubnet"
  resource_group_name  = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name = azurerm_virtual_network.eastus2-spoke1-vnet.name
  address_prefix       = "10.10.1.0/24"
}
resource "azurerm_subnet" "brazilsouth-spoke1-vm-subnet" {
  name                 = "vmsubnet"
  resource_group_name  = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name = azurerm_virtual_network.brazilsouth-spoke1-vnet.name
  address_prefix       = "10.20.1.0/24"
}
resource "azurerm_subnet" "brazilsouth-spoke2-vm-subnet" {
  name                 = "vmsubnet"
  resource_group_name  = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name = azurerm_virtual_network.brazilsouth-spoke2-vnet.name
  address_prefix       = "10.20.2.0/24"
}

#######################################################################
## Create Azure Firewall
#######################################################################
resource "azurerm_public_ip" "eastus2-hub-firewall-pip" {
  name                = "eastus2-hub-firewall-pip"
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_public_ip" "brazilsouth-hub-firewall-pip" {
  name                = "brazilsouth-hub-firewall-pip"
  location            = "brazilsouth"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}

resource "azurerm_firewall" "eastus2-hub-firewall" {
  depends_on=[azurerm_public_ip.eastus2-hub-firewall-pip, azurerm_firewall_policy.base-firewall-Policy]
  name = "eastus2-hub-firewall"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name
  location = "eastus2"
  sku_tier = "Premium"
  firewall_policy_id = azurerm_firewall_policy.base-firewall-Policy.id
  ip_configuration {
    name = "eastus2-hub-firewall"
    subnet_id = azurerm_subnet.eastus2-hub-firewall-subnet.id
    public_ip_address_id = azurerm_public_ip.eastus2-hub-firewall-pip.id
  }
 
  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}

resource "azurerm_firewall" "brazilsouth-hub-firewall" {
  depends_on=[azurerm_public_ip.brazilsouth-hub-firewall-pip, azurerm_firewall_policy.base-firewall-Policy]
  name = "brazilsouth-hub-firewall"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name
  location = "brazilsouth"
  sku_tier = "Premium"
  firewall_policy_id = azurerm_firewall_policy.base-firewall-Policy.id
  ip_configuration {
    name = "brazilsouth-hub-firewall"
    subnet_id = azurerm_subnet.brazilsouth-hub-firewall-subnet.id
    public_ip_address_id = azurerm_public_ip.brazilsouth-hub-firewall-pip.id
  }
 
  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}


#######################################################################
## Create Bastion Services
#######################################################################

resource "azurerm_public_ip" "eastus2-hub-bastion-pip" {
  name                = "eastus2-hub-bastion-pip"
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_public_ip" "brazilsouth-hub-bastion-pip" {
  name                = "brazilsouth-hub-bastion-pip"
  location            = "brazilsouth"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_bastion_host" "eastus2-hub-bastion-host" {
  name                = "eastus2-hub-bastion-host"
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name

  ip_configuration {
    name                 = "eastus2-hub-bastion-host"
    subnet_id            = azurerm_subnet.eastus2-hub-bastion-subnet.id
    public_ip_address_id = azurerm_public_ip.eastus2-hub-bastion-pip.id
  }

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_bastion_host" "brazilsouth-hub-bastion-host" {
  name                = "brazilsouth-hub-bastion-host"
  location            = "brazilsouth"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name

  ip_configuration {
    name                 = "brazilsouth-hub-bastion-host"
    subnet_id            = azurerm_subnet.brazilsouth-hub-bastion-subnet.id
    public_ip_address_id = azurerm_public_ip.brazilsouth-hub-bastion-pip.id
  }

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}


#######################################################################
## Create Network Peering
#######################################################################

resource "azurerm_virtual_network_peering" "eastus2-hub-spoke1-vnet-peer" {
  name                         = "eastus2-hub-spoke1-vnet-peer"
  resource_group_name          = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name         = azurerm_virtual_network.eastus2-hub-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.eastus2-spoke1-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  depends_on                   = [azurerm_virtual_network.eastus2-spoke1-vnet, azurerm_virtual_network.eastus2-hub-vnet, azurerm_virtual_network_gateway.eastus2-hub-vpn-gateway]
}
resource "azurerm_virtual_network_peering" "brazilsouth-hub-spoke1-vnet-peer" {
  name                         = "eastus2-hub-spoke1-vnet-peer"
  resource_group_name          = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name         = azurerm_virtual_network.brazilsouth-hub-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.brazilsouth-spoke1-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  depends_on                   = [azurerm_virtual_network.brazilsouth-spoke1-vnet, azurerm_virtual_network.brazilsouth-hub-vnet, azurerm_virtual_network_gateway.brazilsouth-hub-vpn-gateway]
}
resource "azurerm_virtual_network_peering" "brazilsouth-hub-spoke2-vnet-peer" {
  name                         = "eastus2-hub-spoke2-vnet-peer"
  resource_group_name          = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name         = azurerm_virtual_network.brazilsouth-hub-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.brazilsouth-spoke2-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  depends_on                   = [azurerm_virtual_network.brazilsouth-spoke2-vnet, azurerm_virtual_network.brazilsouth-hub-vnet, azurerm_virtual_network_gateway.brazilsouth-hub-vpn-gateway]
}

#######################################################################
## Create Network Interface
#######################################################################

resource "azurerm_network_interface" "azeastus2vm01-nic" {
  name                 = "azeastus2vm01-nic"
  location             = "eastus2"
  resource_group_name  = azurerm_resource_group.firewall-microhack-rg.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "azeastus2vm01-nic"
    subnet_id                     = azurerm_subnet.eastus2-spoke1-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_network_interface" "azbrsouthvm01-nic" {
  name                 = "azbrsouthvm01-nic"
  location             = "brazilsouth"
  resource_group_name  = azurerm_resource_group.firewall-microhack-rg.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "azbrsouthvm01-nic"
    subnet_id                     = azurerm_subnet.brazilsouth-spoke1-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_network_interface" "azbrsouthvm02-nic" {
  name                 = "azbrsouthvm02-nic"
  location             = "brazilsouth"
  resource_group_name  = azurerm_resource_group.firewall-microhack-rg.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "azbrsouthvm02-nic"
    subnet_id                     = azurerm_subnet.brazilsouth-spoke2-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}


#######################################################################
## Create Virtual Machine
#######################################################################

resource "azurerm_virtual_machine" "azeastus2vm01" {
  name                  = "azeastus2vm01"
  location              = "eastus2"
  resource_group_name   = azurerm_resource_group.firewall-microhack-rg.name
  network_interface_ids = [azurerm_network_interface.azeastus2vm01-nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "azeastus2vm01-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "azeastus2vm01"
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_virtual_machine" "azbrsouthvm01" {
  name                  = "azbrsouthvm01"
  location              = "brazilsouth"
  resource_group_name   = azurerm_resource_group.firewall-microhack-rg.name
  network_interface_ids = [azurerm_network_interface.azbrsouthvm01-nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "azbrsouthvm01-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "azbrsouthvm01"
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}

resource "azurerm_virtual_machine" "azbrsouthvm02" {
  name                  = "azbrsouthvm02"
  location              = "brazilsouth"
  resource_group_name   = azurerm_resource_group.firewall-microhack-rg.name
  network_interface_ids = [azurerm_network_interface.azbrsouthvm02-nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    offer     = "UbuntuServer"
    publisher = "Canonical"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "azbrsouthvm02-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
   }

  os_profile {
    computer_name  = "azbrsouthvm02"
    admin_username = var.username
    admin_password = var.password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}


#############################################################################
## Create Virtual Network Gateway
#############################################################################

resource "azurerm_public_ip" "eastus2-hub-vpn-gateway-pip" {
  name                = "eastus2-hub-vpn-gateway-pip"
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name

  allocation_method = "Dynamic"
}
resource "azurerm_public_ip" "brazilsouth-hub-vpn-gateway-pip" {
  name                = "brazilsouth-hub-vpn-gateway-pip"
  location            = "brazilsouth"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name

  allocation_method = "Dynamic"
}
resource "azurerm_virtual_network_gateway" "eastus2-hub-vpn-gateway" {
  name                = "eastus2-hub-vpn-gateway"
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.eastus2-hub-vpn-gateway-pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.eastus2-hub-GatewaySubnet-vnet.id
  }
  depends_on = [azurerm_public_ip.eastus2-hub-vpn-gateway-pip]

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_virtual_network_gateway" "brazilsouth-hub-vpn-gateway" {
  name                = "brazilsouth-hub-vpn-gateway"
  location            = "brazilsouth"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.brazilsouth-hub-vpn-gateway-pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.brazilsouth-hub-GatewaySubnet-vnet.id
  }
  depends_on = [azurerm_public_ip.brazilsouth-hub-vpn-gateway-pip]

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}

#######################################################################
## Create Connections
#######################################################################

resource "azurerm_virtual_network_gateway_connection" "eastus2-hub-onprem-conn" {
  name                = "eastus2-hub-onprem-conn"
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name

  type           = "Vnet2Vnet"
  routing_weight = 1

  virtual_network_gateway_id      = azurerm_virtual_network_gateway.eastus2-hub-vpn-gateway.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.onprem-vpn-gateway.id

  shared_key = local.shared-key
}
resource "azurerm_virtual_network_gateway_connection" "onprem-eastus2-hub-conn" {
  name                            = "onprem-eastus2-hub-conn"
  location                        = "eastus2"
  resource_group_name             = azurerm_resource_group.firewall-microhack-rg.name
  type                            = "Vnet2Vnet"
  routing_weight                  = 1
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.onprem-vpn-gateway.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.eastus2-hub-vpn-gateway.id

  shared_key = local.shared-key

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_virtual_network_gateway_connection" "brazilsouth-hub-onprem-conn" {
  name                = "brazilsouth-hub-onprem-conn"
  location            = "brazilsouth"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name

  type           = "Vnet2Vnet"
  routing_weight = 1

  virtual_network_gateway_id      = azurerm_virtual_network_gateway.brazilsouth-hub-vpn-gateway.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.onprem-vpn-gateway.id

  shared_key = local.shared-key
}
resource "azurerm_virtual_network_gateway_connection" "onprem-brazilsouth-hub-conn" {
  name                            = "onprem-brazilsouth-hub-conn"
  location                        = "eastus2"
  resource_group_name             = azurerm_resource_group.firewall-microhack-rg.name
  type                            = "Vnet2Vnet"
  routing_weight                  = 1
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.onprem-vpn-gateway.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.brazilsouth-hub-vpn-gateway.id

  shared_key = local.shared-key

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}

#######################################################################
## Create VNet Peering
#######################################################################

resource "azurerm_virtual_network_peering" "spoke1-eastus2-hub-vnet-peer" {
  name                      = "spoke1-eastus2-hub-vnet-peer"
  resource_group_name       = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name      = azurerm_virtual_network.eastus2-spoke1-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.eastus2-hub-vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
  depends_on                   = [azurerm_virtual_network.eastus2-spoke1-vnet, azurerm_virtual_network.eastus2-hub-vnet, azurerm_virtual_network_gateway.eastus2-hub-vpn-gateway]
  
}
resource "azurerm_virtual_network_peering" "spoke1-brazilsouth-hub-vnet-peer" {
  name                      = "spoke1-brazilsouth-hub-vnet-peer"
  resource_group_name       = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name      = azurerm_virtual_network.brazilsouth-spoke1-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.brazilsouth-hub-vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
  depends_on                   = [azurerm_virtual_network.brazilsouth-spoke1-vnet, azurerm_virtual_network.brazilsouth-hub-vnet, azurerm_virtual_network_gateway.brazilsouth-hub-vpn-gateway]
  
}
resource "azurerm_virtual_network_peering" "spoke2-brazilsouth-hub-vnet-peer" {
  name                      = "spoke2-brazilsouth-hub-vnet-peer"
  resource_group_name       = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name      = azurerm_virtual_network.brazilsouth-spoke2-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.brazilsouth-hub-vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
  depends_on                   = [azurerm_virtual_network.brazilsouth-spoke2-vnet, azurerm_virtual_network.brazilsouth-hub-vnet, azurerm_virtual_network_gateway.brazilsouth-hub-vpn-gateway]
  
}
resource "azurerm_virtual_network_peering" "hub-brazilsouth--eastus2-hub-vnet-peer" {
  name                      = "hub-brazilsouth--eastus2-hub-vnet-peer"
  resource_group_name       = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name      = azurerm_virtual_network.brazilsouth-hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.eastus2-hub-vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on                   = [azurerm_virtual_network.brazilsouth-hub-vnet, azurerm_virtual_network.eastus2-hub-vnet]
  
}

resource "azurerm_virtual_network_peering" "hub-eastus2-brazilsouth-hub-vnet-peer" {
  name                      = "hub-eastus2-brazilsouth-hub-vnet-peer"
  resource_group_name       = azurerm_resource_group.firewall-microhack-rg.name
  virtual_network_name      = azurerm_virtual_network.eastus2-hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.brazilsouth-hub-vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on                   = [azurerm_virtual_network.eastus2-hub-vnet, azurerm_virtual_network.brazilsouth-hub-vnet]
  
}

#######################################################################
## Create UDR
#######################################################################

resource "azurerm_route_table" "rt-brsouth-gwsubnet" {
  name                          = "brazilsouth-gwsubnet-rt"
  location                      = "brazilsouth"
  resource_group_name           = azurerm_resource_group.firewall-microhack-rg.name
  disable_bgp_route_propagation = false

  route {
    name           = "to-onprem"
    address_prefix = "192.168.0.0/24"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "10.200.3.4" 
  }

   route {
    name           = "to-brsouth"
    address_prefix = "10.20.1.0/24"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "10.200.3.4" 
  }

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}

resource "azurerm_route_table" "rt-eastus2-spoke1-vmsubnet" {
  name                          = "eastus2-spokes-rt"
  location                      = "eastus2"
  resource_group_name           = azurerm_resource_group.firewall-microhack-rg.name
  disable_bgp_route_propagation = false

  route {
    name           = "to-onprem"
    address_prefix = "192.168.0.0/24"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "10.100.3.4" 
  }

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_route_table" "rt-brazilsouth-spoke1-vmsubnet" {
  name                          = "brazilsouth-spokes-rt"
  location                      = "brazilsouth"
  resource_group_name           = azurerm_resource_group.firewall-microhack-rg.name
  disable_bgp_route_propagation = false


  route {
    name           = "to-onprem"
    address_prefix = "192.168.0.0/24"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "10.200.3.4" 
  }

   route {
    name           = "to-internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "10.200.3.4" 
  }

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_route_table" "rt-brazilsouth-spoke2-vmsubnet" {
  name                          = "brazilsouth-spokes-rt"
  location                      = "brazilsouth"
  resource_group_name           = azurerm_resource_group.firewall-microhack-rg.name
  disable_bgp_route_propagation = false

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_route_table" "rt-brazilsouth-intercnn-fwsubnet" {
  name                          = "brazilsouth-intercnn-rt"
  location                      = "brazilsouth"
  resource_group_name           = azurerm_resource_group.firewall-microhack-rg.name
  disable_bgp_route_propagation = true

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_route_table" "rt-eastus2-intercnn-fwsubnet" {
  name                          = "eastus2-intercnn-rt"
  location                      = "eastus2"
  resource_group_name           = azurerm_resource_group.firewall-microhack-rg.name
  disable_bgp_route_propagation = true

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}



#######################################################################
## Azure Sentinel and Log Analytics
#######################################################################
resource "azurerm_log_analytics_workspace" "loganalytics-workspace-azfw" {
  name                = "aznetsecmonitor"
  location            = "brazilsouth"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name
  sku                 = "free"

  tags ={
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}
resource "azurerm_log_analytics_solution" "loganalytics-solution-sentinel" {
  solution_name         = "SecurityInsights"
  location              = "brazilsouth"
  resource_group_name   = azurerm_resource_group.firewall-microhack-rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.loganalytics-workspace-azfw.id
  workspace_name        = azurerm_log_analytics_workspace.loganalytics-workspace-azfw.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}

#######################################################################
## Enable Diagnostic Settings
#######################################################################

resource "azurerm_monitor_diagnostic_setting" "brazilsouth-hub-firewall-diag" {
  name               = "to_log_analytics"
  target_resource_id = azurerm_firewall.brazilsouth-hub-firewall.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.loganalytics-workspace-azfw.id

  log {
    category = "AzureFirewallApplicationRule"
    
    retention_policy {
      enabled = false
    }
  }

    log {
    category = "AzureFirewallNetworkRule"
    
    retention_policy {
      enabled = false
    }
  }

     log {
    category = "AzureFirewallDnsProxy"
    
    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "eastus2-hub-firewall-diag" {
  name               = "to_log_analytics"
  target_resource_id = azurerm_firewall.eastus2-hub-firewall.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.loganalytics-workspace-azfw.id

  log {
    category = "AzureFirewallApplicationRule"
    
    retention_policy {
      enabled = false
    }
  }

    log {
    category = "AzureFirewallNetworkRule"
    
    retention_policy {
      enabled = false
    }
  }

     log {
    category = "AzureFirewallDnsProxy"
    
    retention_policy {
      enabled = false
    }
  }
 }

#######################################################################
## Azure Firewall Policy and IP Group
#######################################################################
resource "azurerm_firewall_policy" "base-firewall-Policy" {
  name                = "azfw-policy-std"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name
  location            = "brazilsouth"
  sku                 =  "Premium"

  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "apprule-firewall-Policy" {
  name               = "apprule_collection_group"
  firewall_policy_id = azurerm_firewall_policy.base-firewall-Policy.id
  priority           = 100
  application_rule_collection {
    name     = "app_rule_brazil_default_websites"
    priority = 100
    action   = "Allow"
    rule {
      name = "allow_brazil_default_websites"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.20.1.0/24", "10.20.2.0/24"]
      destination_fqdns = ["www.microsoft.com", "azure.archive.ubuntu.com", "kms.core.windows.net"]
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "netrule-firewall-Policy" {
  name               = "netrule_collection_group"
  firewall_policy_id = azurerm_firewall_policy.base-firewall-Policy.id
  priority           = 400

}
resource "azurerm_ip_group" "br-icmp-ipgroup" {
  name                = "icmp-ipgroup"
  location            = "brazilsouth"
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name

  cidrs = ["192.168.0.4", "10.10.1.4"]
  tags = {
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }

}

#######################################################################
## Azure Key Vault and Managed Identity 
#######################################################################

resource "azurerm_user_assigned_identity" "miazfw" {
  resource_group_name = azurerm_resource_group.firewall-microhack-rg.name
  location            = "brazilsouth"
  name                = "miazfw"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "brazilsouth-keyvault" {
  name                        = "aznetsecvault"
  location                    = "brazilsouth"
  resource_group_name         = azurerm_resource_group.firewall-microhack-rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",

    ]

    certificate_permissions = [
      "Get",
      "List",
      "Update",
      "Import",
      "Delete",
      "Create",
    ]


    secret_permissions = [
      "Get",
      "List",
  
    ]

    storage_permissions = [
      "Get",
      "List",
    ]
  }
   tags ={
     environment = "wth"
     deployment  = "terraform"
     wth   = "Network Security with Azure Firewall Premium"
  }
}

resource "azurerm_key_vault_access_policy" "keyVault-policy" {
  key_vault_id = azurerm_key_vault.brazilsouth-keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.miazfw.principal_id

  certificate_permissions = [
    "Get","List",
  ]

  secret_permissions = [
    "Get","List",
  ]
}
