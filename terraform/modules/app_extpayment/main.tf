############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type    = string
  default = "extpayment"
}

variable "registry" {
  type    = string
  default = "mimaurer"
}

variable "image_tag" {
  type    = string
  default = "master"
}

variable "extpayment_tech" {
  type    = string
  default = "python"
}

variable "extpayment_name" {
  type    = string
  default = "payment"
}

variable "extpayment_replicas" {
  type    = number
  default = 1
}

variable "extpayment_min_random_delay" {
  type    = string
  default = "0"
}

variable "extpayment_max_random_delay" {
  type    = string
  default = "1000"
}

variable "extpayment_lagspike_percentage" {
  type    = string
  default = "0.01"
}


############################################################
# INSTALL EXTPAYMENT HELM CHART
############################################################
resource "helm_release" "extpayment" {
  name       = "extpayment"

  chart      = "${path.module}/helm/"
  
  namespace  = var.namespace
  
  set {
    name  = "registry"
    value = var.registry
  }
  
  set {
    name  = "version"
    value = var.image_tag
  }
  
  set {
    name  = "tech"
    value = var.extpayment_tech
  }
  
  set {
    name  = "name"
    value = var.extpayment_name
  }
  
  set {
    name  = "replicas"
    value = var.extpayment_replicas
  }
  
  set {
    name  = "min_random_delay"
    value = var.extpayment_min_random_delay
  }
  
  set {
    name  = "max_random_delay"
    value = var.extpayment_max_random_delay
  }
  
  set {
    name  = "lagspike_percentage"
    value = var.extpayment_lagspike_percentage
  }
}