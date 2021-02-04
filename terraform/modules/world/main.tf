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
  chart      = "../../../world_app/world-app-helm"
  
  namespace  = var.namespace
}
