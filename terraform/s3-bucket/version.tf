# Versiones de Terraform y de los proveedores que usa este ejemplo
terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Proveedor de AWS: region y etiquetas que se ponen a TODO lo que se cree
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Proyecto   = "devops-mioti"
      Gestionado = "terraform"
    }
  }
}
