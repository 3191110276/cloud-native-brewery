provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "iwo" {
  name       = "iwo"

  repository = "./iwo/helm"
  chart      = "cloud-native-brewery-iwo"
  
  set {
    name  = "app"
    value = "brewery"
  }
}