############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type    = string
}

############################################################
# INSTALL WORLD APP
############################################################
resource "helm_release" "world_app" {
  name       = "worldapp"
  chart      = "${path.module}/helm/"
  
  namespace  = var.namespace
}
