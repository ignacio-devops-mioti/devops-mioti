terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  # Estado remoto: los valores llegan en "terraform init -backend-config=..."
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}
