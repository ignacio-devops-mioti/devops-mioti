# ---------------------------------------------------------------
# Sesion 4 - Primer despliegue en Azure: almacenamiento con etiquetas
# terraform init -> terraform plan -> terraform apply -> terraform destroy
# ---------------------------------------------------------------

variable "grupo_recursos" {
  description = "Grupo de recursos (creado en la sesion 3)"
  type        = string
  default     = "rg-devops-mioti"
}

variable "departamento" {
  description = "Departamento al que se imputa el coste (etiqueta)"
  type        = string
  default     = "formacion"
}

locals {
  etiquetas = {
    Proyecto     = "devops-mioti"
    Gestionado   = "terraform"
    Departamento = var.departamento
    Entorno      = "clase"
  }
}

# Leemos un grupo de recursos que ya existe (no lo crea Terraform)
data "azurerm_resource_group" "rg" {
  name = var.grupo_recursos
}

# Los nombres de cuenta de almacenamiento son unicos en todo Azure
resource "random_id" "sufijo" {
  byte_length = 4
}

resource "azurerm_storage_account" "demo" {
  name                     = "stdevopsmioti${random_id.sufijo.hex}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # la replica mas barata

  # Buenas practicas de seguridad
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = local.etiquetas
}

resource "azurerm_storage_container" "ficheros" {
  name                  = "ficheros"
  storage_account_id    = azurerm_storage_account.demo.id
  container_access_type = "private"
}

output "cuenta_almacenamiento" {
  value = azurerm_storage_account.demo.name
}

output "contenedor" {
  value = azurerm_storage_container.ficheros.name
}
