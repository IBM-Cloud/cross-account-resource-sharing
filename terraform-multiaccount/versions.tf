terraform {
  required_version = ">= 1.2.0"
  required_providers {
    ibm = {
      source                = "ibm-cloud/ibm"
      version               = "1.45.1"
      configuration_aliases = [ ibm.project1_account]
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  ibmcloud_timeout = var.ibmcloud_timeout
}

provider "ibm" {
  alias            = "project1_account"
  ibmcloud_api_key = var.ibmcloud_api_key_second_account
  region           = var.region
  ibmcloud_timeout = var.ibmcloud_timeout
} 
