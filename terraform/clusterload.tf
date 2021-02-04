############################################################
# INSTALL CLUSTER LOAD APP
############################################################
resource "kubernetes_resource_quota" "clusterload-quota" {
  count = var.clusterload_deploy ? 1 : 0
  depends_on = [kubernetes_namespace.clusterload]
  
  metadata {
    name = "clusterload-quota"
    namespace = var.clusterload_namespace
  }
  spec {
    hard = {
      pods = var.clusterload_quota_pods
      "requests.cpu" = var.clusterload_quota_cpu_request
      "requests.memory" = var.clusterload_quota_memory_request
      "limits.cpu" = var.clusterload_quota_cpu_limit
      "limits.memory" = var.clusterload_quota_memory_limit
    }
  }
}

resource "kubernetes_deployment" "clusterload" {
  for_each = { for conf in var.clusterload_configurtions : conf.name => conf }
  depends_on = [kubernetes_resource_quota.clusterload-quota]
  
  metadata {
    name = each.value.name
    namespace = var.clusterload_namespace
    labels = {
      app = each.value.name
    }
  }

  spec {
    replicas = each.value.replicas

    selector {
      match_labels = {
        app = each.value.name
      }
    }

    template {
      metadata {
        labels = {
          app = each.value.name
        }
      }

      spec {
        dynamic "container" {
          for_each = each.value.containers
          content {
            name = container.value.name
            image = "beekman9527/cpumemload:latest"
            
          env {
            name  = "RUN_TYPE"
            value = container.value.run_type
          }
          
          env {
            name  = container.value.run_scaler
            value = container.value.run_value
          }

          resources {
            limits = {
              cpu    = container.value.cpu_limit
              memory = container.value.mem_limit
            }
            requests = {
              cpu    = container.value.cpu_request
              memory = container.value.mem_request
            }
          }
            
            termination_message_path = "/dev/termination-log"
            #terminationMessagePolicy: File >> default
            image_pull_policy = "Always"
          }
        }
        
        restart_policy = "Always"
      }
    }
  }
}