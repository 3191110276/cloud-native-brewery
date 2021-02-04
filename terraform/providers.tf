############################################################
# ADD THIRD PARTY PROVIDERS
############################################################
terraform {
  required_providers {
    intersight = {
      source = "CiscoDevNet/intersight"
      version = "0.1.4"
    }
    appdynamics = {
      source = "3191110276/appdynamics"
      version = "0.1.1"
    }
  }
}


############################################################
# CONFIGURE PROVIDERS
############################################################
provider "kubernetes" {
  config_path   = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "intersight" {
  apikey = var.api_key
  secretkeyfile = var.secretkey_file
  endpoint = var.endpoint
}

provider "appdynamics" {
  base_url = "${var.appd_controller_protocol}://${var.appd_controller_hostname}"
  username = "${var.appd_username}@${var.appd_account_name}"
  password = var.appd_password
  token = var.appd_token
}