############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type    = string
  default = "clusterload"
}

variable "clusterload_quota_pods" {
  type    = string
  default = "20"
}

variable "clusterload_quota_cpu_request" {
  type    = string
  default = "2"
}

variable "clusterload_quota_cpu_limit" {
  type    = string
  default = "4"
}

variable "clusterload_quota_memory_request" {
  type    = string
  default = "16Gi"
}

variable "clusterload_quota_memory_limit" {
  type    = string
  default = "32Gi"
}

variable "clusterload_configurtions" {
  type    = list(object({
    name       = string
    replicas   = number
    containers = list(object({
      name = string
      run_type = string
      run_scaler = string
      run_value = string
      cpu_request = string
      cpu_limit = string
      mem_request = string
      mem_limit = string
    }))
  }))
  default = [{
    name = "clusterload"
    replicas = 1
    containers = [
      {
      name = "cpuload"
      run_type = "cpu"
      run_scaler = "CPU_PERCENT"
      run_value = "10"
      cpu_request = "240m"
      cpu_limit = "250m"
      mem_request = "100Mi"
      mem_limit = "128Mi"
      },
      {
      name = "memload"
      run_type= "memory"
      run_scaler = "MEMORY_NUM"
      run_value = "250"
      cpu_request = "50m"
      cpu_limit = "1"
      mem_request = "1Gi"
      mem_limit = "1Gi"
      },
    ]
  }]
}


############################################################
# INSTALL CLUSTERLOAD APP
############################################################
resource "kubernetes_resource_quota" "clusterload-quota" {
  
  metadata {
    name = "clusterload-quota"
    namespace = var.namespace
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
    namespace = var.namespace
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