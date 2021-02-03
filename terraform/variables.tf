############################################################
# General
############################################################
variable "app_name" {
  type    = string
  default = "brewery"
}

############################################################
# Proxy
############################################################
variable "proxy_url" {
  type    = string
  default = ""
}

variable "proxy_host" {
  type    = string
  default = ""
}

variable "proxy_port" {
  type    = string
  default = ""
}

############################################################
# Intersight
############################################################
variable "apikey" {
  type    = string
}

variable "secretkeyfile" {
  type    = string
}

variable "endpoint" {
  type    = string
  default = "https://intersight.com"
}

############################################################
# Apps to deploy
############################################################
variable "brewery_deploy" {
  type    = bool
  default = true
}

variable "world_deploy" {
  type    = bool
  default = true
}

variable "clusterload_deploy" {
  type    = bool
  default = true
}

############################################################
# Components to deploy
############################################################
variable "hxcsi_deploy" {
  type    = bool
  default = true
}

variable "appd_deploy" {
  type    = bool
  default = true
}

variable "iwo_deploy" {
  type    = bool
  default = true
}

variable "observability_deploy" {
  type    = bool
  default = true
}

variable "stealthwatch_deploy" {
  type    = bool
  default = true
}

############################################################
# Namespaces
############################################################
variable "hxcsi_namespace" {
  type    = string
  default = "hx"
}

variable "appd_namespace" {
  type    = string
  default = "appdynamics"
}

variable "iwo_namespace" {
  type    = string
  default = "iwo"
}

variable "observability_namespace" {
  type    = string
  default = "observability"
}

variable "stealthwatch_namespace" {
  type    = string
  default = "swc"
}

variable "extpayment_namespace" {
  type    = string
  default = "ext"
}

variable "extprod_namespace" {
  type    = string
  default = "automation"
}

variable "app_namespace" {
  type    = string
  default = "app"
}

variable "trafficgen_namespace" {
  type    = string
  default = "trafficgen"
}

variable "world_namespace" {
  type    = string
  default = "world"
}

variable "clusterload_namespace" {
  type    = string
  default = "clusterload"
}

variable "appd_ns_to_monitor" {
  type    = list
  default = ["kube-system", "app", "ext", "automation", "world", "clusterload"]
}

############################################################
# Images
############################################################
variable "registry" {
  type    = string
  default = "mimaurer"
}

variable "image_tag" {
  type    = string
  default = "master"
}

############################################################
# CSI
############################################################
variable "storageclass_name" {
  type    = string
  default = "standard"
}

variable "hx_admin_ip" {
  type    = string
}

variable "hx_iscsi_ip" {
  type    = string
}

variable "hx_api_image" {
  type    = string
}

#################
# AppD
#################
variable "appd_account_name" {
  type    = string
}

variable "appd_username" {
  type    = string
}

variable "appd_password" {
  type    = string
}

variable "appd_controller_key" {
  type    = string
}

variable "appd_controller_protocol" {
  type    = string
  default = "https"
}

variable "appd_controller_hostname" {
  type    = string
}

variable "appd_global_account" {
  type    = string
}

variable "appd_controller_port" {
  type    = number
  default = 443
}

variable "appd_controller_ssl" {
  type    = string
  default = "true"
}

variable "appd_browserapp_beaconurl" {
  type    = string
}

variable "appd_token" {
  type    = string
}

############################################################
# Stealthwatch
############################################################
variable "stealthwatch_service_key" {
  type    = string
}

############################################################
# ExtPayment
############################################################
variable "extpayment_name" {
  type    = string
  default = "payment"
}

variable "extpayment_replicas" {
  type    = number
  default = 1
}

variable "extpayment_tech" {
  type    = string
  default = "python"
}

variable "extpayment_min_random_delay" {
  type    = string
  default = "0"
}

variable "extpayment_max_random_delay" {
  type    = string
  default = "1000"
}

variable "extpayment_lagspike_percentage" {
  type    = string
  default = "0.01"
}

############################################################
# ExtProd
############################################################
variable "extprod_name" {
  type    = string
  default = "production"
}

variable "extprod_replicas" {
  type    = number
  default = 1
}

variable "extprod_tech" {
  type    = string
  default = "python"
}

variable "extprod_min_delay" {
  type    = number
  default = 50
}

variable "extprod_max_delay" {
  type    = number
  default = 250
}

variable "extprod_job_min_delay" {
  type    = number
  default = 240
}

variable "extprod_job_max_delay" {
  type    = number
  default = 360
}

variable "production_svc" {
  type    = string
  default = "brewery-production.app.svc"
}

############################################################
# Brewery
############################################################
variable "adminfile_name" {
  type    = string
  default = "adminfile"
}

variable "adminfile_appd" {
  type    = string
  default = "Admin"
}

variable "adminfile_tech" {
  type    = string
  default = "nginx"
}

variable "orderfile_name" {
  type    = string
  default = "orderfile"
}

variable "orderfile_appd" {
  type    = string
  default = "Webserver"
}

variable "orderfile_tech" {
  type    = string
  default = "apache"
}

variable "order_name" {
  type    = string
  default = "order"
}

variable "order_appd" {
  type    = string
  default = "Order"
}

variable "order_tech" {
  type    = string
  default = "python"
}

variable "inventorydb_name" {
  type    = string
  default = "inventorydb"
}

variable "inventorydb_appd" {
  type    = string
  default = "InventoryDB"
}

variable "inventorydb_tech" {
  type    = string
  default = "mariadb"
}

variable "payment_name" {
  type    = string
  default = "payment"
}

variable "payment_appd" {
  type    = string
  default = "Payment"
}

variable "payment_tech" {
  type    = string
  default = "nodejs"
}

variable "payment_min_random_delay" {
  type    = string
  default = "0"
}

variable "payment_max_random_delay" {
  type    = string
  default = "1000"
}

variable "payment_lagspike_percentage" {
  type    = string
  default = "0.01"
}

variable "initqueue_name" {
  type    = string
  default = "orderqueue"
}

variable "initqueue_tech" {
  type    = string
  default = "activemq"
}

variable "orderprocessing_name" {
  type    = string
  default = "orderprocessing"
}

variable "orderprocessing_appd" {
  type    = string
  default = "OrderProcessing"
}

variable "orderprocessing_tech" {
  type    = string
  default = "php"
}

variable "orderprocessing_cpurequest" {
  type    = string
  default = "20m"
}

variable "orderprocessing_memrequest" {
  type    = string
  default = "80Mi"
}

variable "orderprocessing_cpulimit" {
  type    = string
  default = "250m"
}

variable "orderprocessing_memlimit" {
  type    = string
  default = "280Mi"
}

variable "notification_name" {
  type    = string
  default = "notification"
}

variable "notification_appd" {
  type    = string
  default = "Notification"
}

variable "notification_tech" {
  type    = string
  default = "java"
}

variable "prodrequest_name" {
  type    = string
  default = "prodrequest"
}

variable "prodrequest_appd" {
  type    = string
  default = "ProdRequest"
}

variable "prodrequest_tech" {
  type    = string
  default = "java"
}

variable "production_name" {
  type    = string
  default = "production"
}

variable "production_appd" {
  type    = string
  default = "Production"
}

variable "production_tech" {
  type    = string
  default = "python"
}

variable "fulfilment_name" {
  type    = string
  default = "fulfilment"
}

variable "fulfilment_appd" {
  type    = string
  default = "Fulfilment"
}

variable "fulfilment_tech" {
  type    = string
  default = "python"
}

############################################################
# Ext Services
############################################################
variable "extpayment_svc" {
  type    = string
  default = "payment.ext"
}

variable "extprod_svc" {
  type    = string
  default = "production.automation"
}

############################################################
# Trafficgen
############################################################
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
# ClusterLoad
############################################################
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