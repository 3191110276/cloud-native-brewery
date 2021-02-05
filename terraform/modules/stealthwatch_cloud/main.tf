############################################################
# REQUIRED PROVIDERS
############################################################
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.2"
    }
  }
}


############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type    = string
  default = "swc"
}

variable "stealthwatch_service_key" {
  type    = string
}


############################################################
# INSTALL STEALTHWATCH HELM CHART
############################################################
resource "helm_release" "stealthwatch" {
  name       = "stealthwatch"

  chart      = "${path.module}/helm/"
  
  namespace  = var.namespace
  
  set {
    name  = "stlth_service_key"
    value = var.stealthwatch_service_key
  }
}