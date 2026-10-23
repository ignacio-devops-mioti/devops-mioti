# Estado remoto en Azure (sesion 5). Los valores concretos se pasan en
# "terraform init -backend-config=..." para no fijarlos en el codigo.
terraform {
  backend "azurerm" {}
}
