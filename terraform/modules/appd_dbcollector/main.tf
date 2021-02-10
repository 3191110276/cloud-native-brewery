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

variable "namespace" {
  type    = string
  default = "appdynamics"
}

variable "appd_account_name" {
  type    = string
}

variable "appd_controller_key" {
  type    = string
}

variable "appd_controller_hostname" {
  type    = string
}

variable "appd_controller_ssl" {
  type    = string
  default = "true"
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
# INSTALL APPDYNAMICS DB COLLECTOR
############################################################
resource "kubernetes_config_map" "dbcollector" {
  metadata {
    name = "dbcollector-config"
    namespace = var.namespace
  }

  data = {
    ACCOUNT_NAME = var.appd_account_name
    CONTROLLER_HOST = var.appd_controller_hostname
    CONTROLLER_PORT = 443
    CONTROLLER_SSL = var.appd_controller_ssl
    ACCESS_KEY = var.appd_controller_key
    APP_NAME = var.app_name
    PROXY_HOST = var.proxy_host
    PROXY_PORT: var.proxy_port
  }
}

resource "kubernetes_deployment" "dbcollector" {
  metadata {
    name = "appd-dbagent"
    namespace = var.namespace
    labels = {
      app = "appd-dbagent"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "appd-dbagent"
      }
    }

    template {
      metadata {
        labels = {
          app = "appd-dbagent"
        }
      }

      spec {
        container {
          image = "${var.registry}/appd-dbagent:${var.image_tag}"
          name  = "appd-dbagent"
          env_from {
            config_map_ref {
              name = "dbcollector-config"
            }
          }
        }
      }
    }
  }
}