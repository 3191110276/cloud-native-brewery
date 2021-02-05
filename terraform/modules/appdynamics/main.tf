############################################################
# INPUT VARIABLES
############################################################
variable "app_name" {
  type    = string
}

variable "registry" {
  type    = string
  default = "mimaurer"
}

variable "image_tag" {
  type    = string
  default = "master"
}

variable "appd_namespace" {
  type    = string
  default = "appdynamics"
}

variable "appd_account_name" {
  type    = string
}

variable "appd_username" {
  type    = string
}

variable "appd_password" {
  type    = string
}

variable "appd_controller_key" {
  type    = string
}

variable "appd_controller_protocol" {
  type    = string
  default = "https"
}

variable "appd_controller_hostname" {
  type    = string
}

variable "appd_global_account" {
  type    = string
}

variable "appd_controller_port" {
  type    = number
  default = 443
}

variable "appd_controller_ssl" {
  type    = string
  default = "true"
}

variable "appd_browserapp_beaconurl" {
  type    = string
}

variable "appd_token" {
  type    = string
}

variable "appd_ns_to_monitor" {
  type    = list
  default = ["kube-system", "app", "ext", "automation", "world", "clusterload"]
}

variable "proxy_url" {
  type    = string
  default = ""
}

variable "proxy_host" {
  type    = string
  default = ""
}

variable "proxy_port" {
  type    = string
  default = ""
}


############################################################
# INSTALL APPDYNAMICS HELM CHART
############################################################
resource "helm_release" "appdynamics" {
  name       = "appd"

  chart      = "${path.module}/helm/"
  
  namespace  = var.appd_namespace
  
  set {
    name  = "registry"
    value = var.registry
  }
  
  set {
    name  = "appname"
    value = var.app_name
  }
  
  set {
    name  = "appd_controller_port"
    value = var.appd_controller_port
  }
  
  set {
    name  = "appd_controller_ssl"
    value = var.appd_controller_ssl
  }
  
  set {
    name  = "dbagent_version"
    value = var.image_tag
  }
  
  set {
    name  = "appd_account_name"
    value = var.appd_account_name
  }
  
  set {
    name  = "appd_username"
    value = var.appd_username
  }
  
  set {
    name  = "appd_password"
    value = var.appd_password
  }
  
  set {
    name  = "appd_controller_key"
    value = var.appd_controller_key
  }
  
  set {
    name  = "appd_controller_hostname"
    value = var.appd_controller_hostname
  }
  
  set {
    name  = "appd_global_account"
    value = var.appd_global_account
  }
  
  set {
    name  = "ns_to_monitor"
    value = "{${join(",", var.appd_ns_to_monitor)}}"
  }
  
  set {
    name  = "proxy_url"
    value = var.proxy_url
  }
  
  set {
    name  = "proxy_host"
    value = var.proxy_host
  }
  
  set {
    name  = "proxy_port"
    value = var.proxy_port
  }
}