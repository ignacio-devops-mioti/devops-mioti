# ---------------------------------------------------------------
# Reto final DevOps: maquina virtual Linux con su red y una alerta
# ---------------------------------------------------------------

variable "grupo_recursos" {
  type    = string
  default = "rg-devops-mioti"
}

variable "region" {
  description = "North Europe no ofrece VM pequenas a cuentas gratuitas: usamos Sweden Central"
  type        = string
  default     = "swedencentral"
}

variable "tamano" {
  description = "B2ats_v2: incluida en los servicios gratuitos de 12 meses (750 h/mes)"
  type        = string
  default     = "Standard_B2ats_v2"
}

locals {
  etiquetas = {
    Proyecto   = "devops-mioti"
    Gestionado = "terraform"
    Entorno    = "reto"
  }
}

data "azurerm_resource_group" "rg" {
  name = var.grupo_recursos
}

# Red privada: la VM NO tiene IP publica
resource "azurerm_virtual_network" "red" {
  name                = "vnet-reto"
  address_space       = ["10.20.0.0/16"]
  location            = var.region
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.etiquetas
}

resource "azurerm_subnet" "subred" {
  name                 = "snet-reto"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.red.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-reto"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.etiquetas

  ip_configuration {
    name                          = "interna"
    subnet_id                     = azurerm_subnet.subred.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "vm-reto-mioti"
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = var.region
  size                  = var.tamano
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic.id]
  tags                  = local.etiquetas

  # Solo clave publica: nada de contrasenas (sesion 2)
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/id_reto.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

# Observabilidad como codigo (sesion 6): alerta si la CPU pasa del 80 %
data "azurerm_monitor_action_group" "correo" {
  name                = "ag-devops-correo"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_monitor_metric_alert" "cpu" {
  name                = "alerta-cpu-vm-reto"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [azurerm_linux_virtual_machine.vm.id]
  description         = "CPU media por encima del 80 % durante 5 minutos"
  severity            = 2
  window_size         = "PT5M"
  frequency           = "PT1M"
  tags                = local.etiquetas

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = data.azurerm_monitor_action_group.correo.id
  }
}

output "vm" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "ip_privada" {
  value = azurerm_network_interface.nic.private_ip_address
}
