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

variable "extprod_tech" {
  type    = string
  default = "python"
}

variable "extprod_name" {
  type    = string
  default = "payment"
}

variable "extprod_replicas" {
  type    = number
  default = 1
}

variable "extprod_min_delay" {
  type    = string
  default = "0"
}

variable "extprod_max_delay" {
  type    = string
  default = "1000"
}

variable "extprod_job_min_delay" {
  type    = number
  default = 240
}

variable "extprod_job_max_delay" {
  type    = number
  default = 360
}

variable "production_svc" {
  type    = string
  default = "brewery-production.app.svc"
}


############################################################
# INSTALL EXTPROD HELM CHART
############################################################
resource "helm_release" "extprod" {
  name       = "extprod"

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
    value = var.extprod_tech
  }
  
  set {
    name  = "name"
    value = var.extprod_name
  }
  
  set {
    name  = "replicas"
    value = var.extprod_replicas
  }
  
  set {
    name  = "min_delay"
    value = var.extprod_min_delay
  }
  
  set {
    name  = "max_delay"
    value = var.extprod_max_delay
  }
  
  set {
    name  = "job_min_delay"
    value = var.extprod_job_min_delay
  }
  
  set {
    name  = "job_max_delay"
    value = var.extprod_job_max_delay
  }
  
  set {
    name  = "production_svc"
    value = var.production_svc
  }
}