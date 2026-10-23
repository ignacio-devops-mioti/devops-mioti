# Versiones de Terraform y de los proveedores que usa este ejemplo
terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Proveedor de Azure. La suscripcion NO va en el codigo:
# se lee de la variable de entorno ARM_SUBSCRIPTION_ID
provider "azurerm" {
  features {}
}
