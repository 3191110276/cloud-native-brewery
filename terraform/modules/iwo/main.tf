############################################################
# REQUIRED PROVIDERS
############################################################
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
  }
}


############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type    = string
  default = "iwo"
}

variable "app_name" {
  type    = string
  default = "brewery"
}


############################################################
# INSTALL IWO
############################################################
resource "kubernetes_service_account" "iwo-user" {
  metadata {
    name = "iwo-user"
    namespace = var.namespace
  }
}


resource "kubernetes_cluster_role_binding" "iwo-all-binding" {
  depends_on = [kubernetes_service_account.iwo-user]
  metadata {
    name = "iwo-all-binding"
    #namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "iwo-user"
    namespace = var.namespace
    #api_group = "rbac.authorization.k8s.io"
  }
}


resource "kubernetes_config_map" "iwo-config" {
  metadata {
    name = "iwo-config"
    namespace = var.namespace
  }

  data = {
    "iwo.config" = <<EOT
    {
      "communicationConfig": {
        "serverMeta": {
          "proxy": "http://localhost:9004",
          "version": "8",
          "turboServer": "http://topology-processor:8080"
        }
      },
      "HANodeConfig": {
        "nodeRoles": ["master"]
      },
      "targetConfig": {
        "targetName":"${var.app_name}-cluster"
      },
      "daemonPodDetectors": {
        "namespaces": [],
        "podNamePatterns": []
      }
    }
    EOT
  }
}


resource "kubernetes_deployment" "iwok8scollector" {
  depends_on = [kubernetes_config_map.iwo-config]
  metadata {
    name = "iwok8scollector"
    namespace = var.namespace
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        "app.kubernetes.io/name" = "iwok8scollector"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "iwok8scollector"
        }
        annotations = {
          "kubeturbo.io/controllable" = "false"
        }
      }

      spec {
        service_account_name = "iwo-user"
        automount_service_account_token = "true"
        image_pull_secrets {
          name = "dockerhub.cisco.comdockerhub.cisco.com"
        }
        container {
          image = "intersight/kubeturbo:8.0.1"
          name  = "iwo-k8s-collector"
          image_pull_policy = "IfNotPresent"
          args = ["--turboconfig=/etc/iwo/iwo.config", "--v=2", "--kubelet-https=true", "--kubelet-port=10250"]
          volume_mount {
            name = "iwo-volume"
            mount_path = "/etc/iwo"
            read_only = "true"
          }
          volume_mount {
            name = "varlog"
            mount_path = "/var/log"
          }
        }
        container {
          image = "intersight/pasadena:1.0.9-1"
          name  = "iwo-k8s-dc"
          image_pull_policy = "IfNotPresent"
          volume_mount {
            name = "varlog"
            mount_path = "/cisco/pasadena/logs"
          }
          env {
            name = "PROXY_PORT"
            value = "9004"
          }
        }
        volume {
          name = "iwo-volume"
          config_map {
            name = "iwo-config"
          }
        }
        volume {
          name = "varlog"
          empty_dir {}
        }
        restart_policy = "Always"
      }
    }
  }
}