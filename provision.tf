############################################################
# SET DEFAULT VARIABLES
############################################################
variable "app_name" {
  type    = string
  default = "brewery"
}

variable "hxcsi_namespace" {
  type    = string
  default = "hx"
}

variable "appd_namespace" {
  type    = string
  default = "appdynamics"
}

variable "iwo_namespace" {
  type    = string
  default = "iwo"
}

variable "observability_namespace" {
  type    = string
  default = "observability"
}

variable "stealthwatch_namespace" {
  type    = string
  default = "swc"
}

variable "extpayment_namespace" {
  type    = string
  default = "ext"
}

variable "extprod_namespace" {
  type    = string
  default = "automation"
}

variable "app_namespace" {
  type    = string
  default = "app"
}

variable "trafficgen_namespace" {
  type    = string
  default = "trafficgen"
}

variable "registry" {
  type    = string
  default = "mimaurer"
}

variable "image_tag" {
  type    = string
  default = "dev"
}

variable "trafficgen_name" {
  type    = string
  default = "trafficgen"
}

variable "trafficgen_replicas" {
  type    = number
  default = 10
}

variable "trafficgen_min_random_delay" {
  type    = number
  default = 0
}

variable "trafficgen_max_random_delay" {
  type    = number
  default = 60
}

variable "trafficgen_app_endpoint" {
  type    = string
  default = "ingress-nginx-controller.ccp"
}


############################################################
# ADD THIRD PARTY PROVIDERS
############################################################
terraform {
  required_providers {
    intersight = {
      source = "CiscoDevNet/intersight"
      version = "0.1.4"
    }
  }
}


############################################################
# CONFIGURE PROVIDERS
############################################################
provider "kubernetes" {}

provider "null" {}

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


############################################################
# CREATE KUBERNETES NAMESPACES
############################################################
resource "kubernetes_namespace" "hxcsi" {
  metadata {
    name = var.hxcsi_namespace
  }
}

resource "kubernetes_namespace" "appdynamics" {
  metadata {
    name = var.appd_namespace
  }
}

resource "kubernetes_namespace" "iwo" {
  metadata {
    name = var.iwo_namespace
  }
}

resource "kubernetes_namespace" "observability" {
  metadata {
    name = var.observability_namespace
  }
}

resource "kubernetes_namespace" "stealthwatch" {
  metadata {
    name = var.stealthwatch_namespace
  }
}

resource "kubernetes_namespace" "extpayment" {
  metadata {
    name = var.extpayment_namespace
  }
}

resource "kubernetes_namespace" "extprod" {
  metadata {
    name = var.extprod_namespace
  }
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = var.app_namespace
  }
}

resource "kubernetes_namespace" "trafficgen" {
  metadata {
    name = var.trafficgen_namespace
  }
}


# TODO: CREATE APP IN APPD


# TODO: CREATE EUM APP IN APPD


# TODO: CREATE DB IN APPD


############################################################
# INSTALL HX-CSI HELM CHART
############################################################
resource "helm_release" "hxcsi" {
  name       = "hxcsi"
  depends_on = [kubernetes_namespace.hxcsi]

  chart      = "./hx_csi/helm"
  
  namespace  = var.hxcsi_namespace
}


############################################################
# INSTALL APPDYNAMICS HELM CHART
############################################################
resource "helm_release" "appdynamics" {
  name       = "appd"
  depends_on = [kubernetes_namespace.appdynamics]

  chart      = "./appdynamics/helm"
  
  namespace  = var.appd_namespace
}


############################################################
# INSTALL IWO HELM CHART
############################################################
resource "helm_release" "iwo" {
  name       = "iwo"
  depends_on = [kubernetes_namespace.iwo]

  chart      = "./iwo/helm"
  
  namespace  = var.iwo_namespace

  set {
    name  = "clustername"
    value = var.app_name
  }
}


# TODO: GET TOKEN FOR IWO CLAIM


# TODO: CLAIM IWO IN INTERSIGHT


############################################################
# INSTALL OBSERVABILITY HELM CHART
############################################################
resource "helm_release" "observability" {
  name       = "observability"
  depends_on = [kubernetes_namespace.observability]

  chart      = "./observability/helm"
  
  namespace  = var.observability_namespace
}


############################################################
# INSTALL STEALTHWATCH HELM CHART
############################################################
resource "helm_release" "stealthwatch" {
  name       = "stealthwatch"
  depends_on = [kubernetes_namespace.stealthwatch]

  chart      = "./stealthwatch_cloud/helm"
  
  namespace  = var.stealthwatch_namespace
}


############################################################
# INSTALL EXTPAYMENT HELM CHART
############################################################
resource "helm_release" "extpayment" {
  name       = "extpayment"
  depends_on = [kubernetes_namespace.extpayment]

  chart      = "./app_extpayment/helm"
  
  namespace  = var.extpayment_namespace
}


############################################################
# INSTALL EXTPROD HELM CHART
############################################################
resource "helm_release" "extprod" {
  name       = "extprod"
  depends_on = [kubernetes_namespace.extprod]

  chart      = "./app_extprod/helm"
  
  namespace  = var.extprod_namespace
}


############################################################
# INSTALL APP HELM CHART
############################################################
resource "helm_release" "app" {
  name       = "app"
  depends_on = [kubernetes_namespace.app]

  chart      = "./app_main/helm"
  
  namespace  = var.app_namespace
}


############################################################
# INSTALL TRAFFICGENERATOR HELM CHART
############################################################
resource "helm_release" "trafficgen" {
  name       = "trafficgen"
  depends_on = [kubernetes_namespace.trafficgen]

  chart      = "./trafficgen/helm"
  
  namespace  = var.trafficgen_namespace
  
  set {
    name  = "registry"
    value = var.registry
  }
  
  set {
    name  = "name"
    value = var.trafficgen_name
  }
  
  set {
    name  = "version"
    value = var.image_tag
  }
  
  set {
    name  = "app_endpoint"
    value = var.trafficgen_app_endpoint
  }
  
  set {
    name  = "replicas"
    value = var.trafficgen_replicas
  }
  
  set {
    name  = "min_random_delay"
    value = var.trafficgen_min_random_delay
  }
  
  set {
    name  = "max_random_delay"
    value = var.trafficgen_max_random_delay
  }
}