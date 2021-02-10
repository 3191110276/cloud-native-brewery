############################################################
# CREATE KUBERNETES NAMESPACES
############################################################
resource "kubernetes_namespace" "hxcsi" {
  count = var.hxcsi_deploy ? 1 : 0
  metadata {
    name = var.hxcsi_namespace
  }
}

resource "kubernetes_namespace" "mesh" {
  count = var.mesh_deploy ? 1 : 0
  metadata {
    name = var.mesh_namespace
  }
}

resource "kubernetes_namespace" "appdynamics" {
  count = var.appd_deploy ? 1 : 0
  metadata {
    name = var.appd_namespace
  }
}

resource "kubernetes_namespace" "iwo" {
  count = var.iwo_deploy ? 1 : 0
  metadata {
    name = var.iwo_namespace
  }
}

resource "kubernetes_namespace" "observability" {
  count = var.observability_deploy ? 1 : 0
  metadata {
    name = var.observability_namespace
  }
}

resource "kubernetes_namespace" "stealthwatch" {
  count = var.stealthwatch_deploy ? 1 : 0
  metadata {
    name = var.stealthwatch_namespace
  }
}

resource "kubernetes_namespace" "extpayment" {
  count = var.brewery_deploy ? 1 : 0
  metadata {
    name = var.extpayment_namespace
  }
}

resource "kubernetes_namespace" "extprod" {
  count = var.brewery_deploy ? 1 : 0
  metadata {
    name = var.extprod_namespace
  }
}

resource "kubernetes_namespace" "app" {
  count = var.brewery_deploy ? 1 : 0
  metadata {
    name = var.app_namespace
  }
}

resource "kubernetes_namespace" "trafficgen" {
  count = var.brewery_deploy ? 1 : 0
  metadata {
    name = var.trafficgen_namespace
  }
}

resource "kubernetes_namespace" "world" {
  count = var.world_deploy ? 1 : 0
  metadata {
    name = var.world_namespace
  }
}

resource "kubernetes_namespace" "clusterload" {
  count = var.clusterload_deploy ? 1 : 0
  metadata {
    name = var.clusterload_namespace
  }
}