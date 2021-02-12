############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type    = string
  default = "observability"
}


############################################################
# INSTALL OBSERVABILITY HELM CHART
############################################################
resource "helm_release" "observability" {
  name       = "observability"

  chart      = "${path.module}/helm/"
  
  namespace  = var.namespace
}