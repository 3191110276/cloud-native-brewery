############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type    = string
  default = "hx"
}


############################################################
# INSTALL HX-CSI HELM CHART
############################################################
resource "helm_release" "hxcsi" {
  name       = "hxcsi"

  chart      = "${path.module}/helm/"
  
  namespace  = var.namespace
}