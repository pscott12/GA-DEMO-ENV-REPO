terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.29.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~>3.7.2"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "payson-terraform-projects"

    workspaces {
      name = "GA-DEMO-ENV-WKSP"
    }

  }
}

provider "azurerm" {
  features {}
}

