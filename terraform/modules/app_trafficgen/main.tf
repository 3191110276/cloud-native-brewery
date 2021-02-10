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

variable "trafficgen_name" {
  type    = string
  default = "trafficgen"
}

variable "trafficgen_replicas" {
  type    = number
  default = 10
}

variable "trafficgen_min_random_delay" {
  type    = number
  default = 0
}

variable "trafficgen_max_random_delay" {
  type    = number
  default = 60
}

variable "trafficgen_app_endpoint" {
  type    = string
  default = "ingress-nginx-controller.ccp"
}



############################################################
# INSTALL TRAFFICGENERATOR
############################################################
resource "kubernetes_config_map" "trafficgen" {

  metadata {
    name = var.trafficgen_name
    namespace = var.namespace
  }

  data = {
    MIN_RANDOM_DELAY    = var.trafficgen_min_random_delay
    MAX_RANDOM_DELAY    = var.trafficgen_max_random_delay
    LAGSPIKE_PERCENTAGE = ""
    APP_ENDPOINT        = var.trafficgen_app_endpoint
  }
}

resource "kubernetes_service_account" "trafficgen" {
  
  metadata {
    name = var.trafficgen_name
    namespace = var.namespace
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "trafficgen" {
  
  metadata {
    name = var.trafficgen_name
  }

  rule {
    api_groups = [""]
    resources  = ["*","services"]
    verbs      = ["*","get", "watch", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "trafficgen" {
  depends_on = [kubernetes_service_account.trafficgen,kubernetes_cluster_role.trafficgen]
  
  metadata {
    name = var.trafficgen_name
  }
  
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "trafficgen"
  }
  
  subject {
    kind      = "ServiceAccount"
    name      = "trafficgen"
  }
}

resource "kubernetes_cron_job" "demo" {
  depends_on = [kubernetes_config_map.trafficgen,kubernetes_cluster_role_binding.trafficgen]
  
  metadata {
    name = var.trafficgen_name
    namespace = var.namespace
  }
  
  spec {
    schedule                      = "* * * * *"
    concurrency_policy            = "Allow"
    successful_jobs_history_limit = 0
    failed_jobs_history_limit     = 1
    starting_deadline_seconds     = 59
    job_template {
      metadata {}
      spec {
        parallelism = var.trafficgen_replicas
        completions = var.trafficgen_replicas * 2
        template {
          metadata {}
          spec {
            service_account_name = var.trafficgen_name
            automount_service_account_token = true
            restart_policy = "Never"
            container {
              name    = "trafficgen"
              image   = "${var.registry}/trafficgen-python:${var.image_tag}"
              image_pull_policy = "IfNotPresent"
              volume_mount {
                name = "customization"
                mount_path = "/etc/customization"
              }
            }
            volume {
              name = "customization"
              config_map {
                name = var.trafficgen_name
              }
            }
          }
        }
      }
    }
  }
}