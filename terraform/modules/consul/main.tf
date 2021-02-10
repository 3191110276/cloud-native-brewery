############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type    = string
  default = "mesh"
}


############################################################
# INSTALL CONSUL HELM CHART
############################################################
resource "helm_release" "consul" {
  name       = "consul"

  chart      = "${path.module}/helm/"
}