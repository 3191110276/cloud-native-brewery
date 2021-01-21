############################################################
# SET DEFAULT VARIABLES
############################################################

#################
# General
#################
variable "app_name" {
  type    = string
  default = "brewery"
}

#################
# Proxy
#################
variable "proxy_url" {
  type    = string
}

variable "proxy_host" {
  type    = string
}

variable "proxy_port" {
  type    = number
}

#################
# Intersight
#################
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

#################
# Namespaces
#################
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

variable "appd_ns_to_monitor" {
  type    = list
  default = ["kube-system", "app", "ext", "automation"]
}

#################
# Images
#################
variable "registry" {
  type    = string
  default = "mimaurer"
}

variable "image_tag" {
  type    = string
  default = "master"
}

#################
# CSI
#################
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

variable "appd_browserapp_key" {
  type    = string
}

#################
# Stealthwatch
#################
variable "stealthwatch_service_key" {
  type    = string
}

#################
# ExtPayment
#################
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

#################
# ExtProd
#################
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

#################
# App
#################
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

#################
# Ext Services
#################
variable "extpayment_svc" {
  type    = string
  default = "payment.ext"
}

variable "extprod_svc" {
  type    = string
  default = "production.automation"
}

#################
# Trafficgen
#################
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
# ADD THIRD PARTY PROVIDERS
############################################################
terraform {
  required_providers {
    intersight = {
      source = "CiscoDevNet/intersight"
      version = "0.1.4"
    }
  }
}


############################################################
# CONFIGURE PROVIDERS
############################################################
provider "kubernetes" {}

provider "null" {}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "intersight" {
  apikey = var.api_key
  secretkeyfile = var.secretkey_file
  endpoint = var.endpoint
}


############################################################
# CREATE KUBERNETES NAMESPACES
############################################################
resource "kubernetes_namespace" "hxcsi" {
  metadata {
    name = var.hxcsi_namespace
  }
}

resource "kubernetes_namespace" "appdynamics" {
  metadata {
    name = var.appd_namespace
  }
}

resource "kubernetes_namespace" "iwo" {
  metadata {
    name = var.iwo_namespace
  }
}

resource "kubernetes_namespace" "observability" {
  metadata {
    name = var.observability_namespace
  }
}

resource "kubernetes_namespace" "stealthwatch" {
  metadata {
    name = var.stealthwatch_namespace
  }
}

resource "kubernetes_namespace" "extpayment" {
  metadata {
    name = var.extpayment_namespace
  }
}

resource "kubernetes_namespace" "extprod" {
  metadata {
    name = var.extprod_namespace
  }
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = var.app_namespace
  }
}

resource "kubernetes_namespace" "trafficgen" {
  metadata {
    name = var.trafficgen_namespace
  }
}


############################################################
# CREATE APP IN APPD
############################################################
# TODO


############################################################
# CREATE EUM APP IN APPD
############################################################
# TODO


############################################################
# CREATE DB IN APPD
############################################################
# TODO


############################################################
# INSTALL HX-CSI HELM CHART
############################################################
resource "helm_release" "hxcsi" {
  name       = "hxcsi"
  depends_on = [kubernetes_namespace.hxcsi]

  chart      = "./hx_csi/helm"
  
  namespace  = var.hxcsi_namespace
}


############################################################
# INSTALL APPDYNAMICS HELM CHART
############################################################
resource "helm_release" "appdynamics" {
  name       = "appd"
  depends_on = [kubernetes_namespace.appdynamics]

  chart      = "./appdynamics/helm"
  
  namespace  = var.appd_namespace
  
  set {
    name  = "registry"
    value = var.registry
  }
  
  set {
    name  = "appname"
    value = var.app_name
  }
  
  set {
    name  = "appd_controller_port"
    value = var.appd_controller_port
  }
  
  set {
    name  = "appd_controller_ssl"
    value = var.appd_controller_ssl
  }
  
  set {
    name  = "dbagent_version"
    value = var.image_tag
  }
  
  set {
    name  = "appd_account_name"
    value = var.appd_account_name
  }
  
  set {
    name  = "appd_username"
    value = var.appd_username
  }
  
  set {
    name  = "appd_password"
    value = var.appd_password
  }
  
  set {
    name  = "appd_controller_key"
    value = var.appd_controller_key
  }
  
  set {
    name  = "appd_controller_hostname"
    value = var.appd_controller_hostname
  }
  
  set {
    name  = "appd_global_account"
    value = var.appd_global_account
  }
  
  set {
    name  = "ns_to_monitor"
    value = "{${join(",", var.appd_ns_to_monitor)}}"
  }
  
  set {
    name  = "proxy_url"
    value = var.proxy_url
  }
  
  set {
    name  = "proxy_host"
    value = var.proxy_host
  }
  
  set {
    name  = "proxy_port"
    value = var.proxy_port
  }
}

############################################################
# INSTALL IWO HELM CHART
############################################################
resource "kubernetes_service_account" "iwo-user" {
  depends_on = [kubernetes_namespace.iwo]
  metadata {
    name = "iwo-user"
    namespace = var.iwo_namespace
  }
}

resource "kubernetes_cluster_role_binding" "iwo-all-binding" {
  depends_on = [kubernetes_service_account.iwo-user]
  metadata {
    name = "iwo-all-binding"
    #namespace = var.iwo_namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "iwo-user"
    namespace = var.iwo_namespace
    #api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_config_map" "iwo-config" {
  depends_on = [kubernetes_namespace.iwo]
  metadata {
    name = "iwo-config"
    namespace = var.iwo_namespace
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
      }
    }
    EOT
  }
}

resource "kubernetes_deployment" "iwok8scollector" {
  depends_on = [kubernetes_config_map.iwo-config]
  metadata {
    name = "iwok8scollector"
    namespace = var.iwo_namespace
  }

  spec {
    replicas = 1

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


############################################################
# GET TOKEN FOR IWO CLAIM
############################################################
data "external" "iwo_token" {
  depends_on = [kubernetes_deployment.iwok8scollector]
  program = ["bash", "./iwo/register.sh"]
  query = {
    proxy_host = var.proxy_host
    proxy_port = var.proxy_port
  }
}

#data "kubernetes_pod" "test" {
#  depends_on = [helm_release.iwo]
#
#  metadata {
#    name = "iwo-dc"
#    namespace = var.iwo_namespace
#  }
#}
# TODO



#$(kubectl -n iwo exec -it $POD -- curl -s http://localhost:9110/SecurityTokens | jq '.[].Token')

############################################################
# CLAIM IWO DEVICE CONNECTOR IN INTERSIGHT
############################################################
# TODO

#resource "intersight_asset_target" "iwo-dc" {
#  depends_on = [external.iwo_token]
#  
#  target_type = "Kubernetes"
#}

# data.external.result.iwo_token

#curl 'https://intersight.com/api/v1/asset/DeviceClaims' \
#  --data-raw '{"SerialNumber":"616aa0f5-0fed-42e3-8bfb-1387f66b43de","SecurityToken":"F393D1A69CA0"}' \


############################################################
# INSTALL OBSERVABILITY HELM CHART
############################################################
resource "helm_release" "observability" {
  name       = "observability"
  depends_on = [kubernetes_namespace.observability]

  chart      = "./observability/helm"
  
  namespace  = var.observability_namespace
}


############################################################
# INSTALL STEALTHWATCH HELM CHART
############################################################
resource "helm_release" "stealthwatch" {
  name       = "stealthwatch"
  depends_on = [kubernetes_namespace.stealthwatch]

  chart      = "./stealthwatch_cloud/helm"
  
  namespace  = var.stealthwatch_namespace
  
  set {
    name  = "stlth_service_key"
    value = var.stealthwatch_service_key
  }
}


############################################################
# INSTALL EXTPAYMENT HELM CHART
############################################################
resource "helm_release" "extpayment" {
  name       = "extpayment"
  depends_on = [kubernetes_namespace.extpayment]

  chart      = "./app_extpayment/helm"
  
  namespace  = var.extpayment_namespace
  
  set {
    name  = "registry"
    value = var.registry
  }
  
  set {
    name  = "version"
    value = var.image_tag
  }
  
  set {
    name  = "tech"
    value = var.extpayment_tech
  }
  
  set {
    name  = "name"
    value = var.extpayment_name
  }
  
  set {
    name  = "replicas"
    value = var.extpayment_replicas
  }
  
  set {
    name  = "min_random_delay"
    value = var.extpayment_min_random_delay
  }
  
  set {
    name  = "max_random_delay"
    value = var.extpayment_max_random_delay
  }
  
  set {
    name  = "lagspike_percentage"
    value = var.extpayment_lagspike_percentage
  }
}


############################################################
# INSTALL EXTPROD HELM CHART
############################################################
resource "helm_release" "extprod" {
  name       = "extprod"
  depends_on = [kubernetes_namespace.extprod]

  chart      = "./app_extprod/helm"
  
  namespace  = var.extprod_namespace
  
  set {
    name  = "registry"
    value = var.registry
  }
  
  set {
    name  = "version"
    value = var.image_tag
  }
  
  set {
    name  = "tech"
    value = var.extprod_tech
  }
  
  set {
    name  = "name"
    value = var.extprod_name
  }
  
  set {
    name  = "replicas"
    value = var.extprod_replicas
  }
  
  set {
    name  = "min_delay"
    value = var.extprod_min_delay
  }
  
  set {
    name  = "max_delay"
    value = var.extprod_max_delay
  }
  
  set {
    name  = "job_min_delay"
    value = var.extprod_job_min_delay
  }
  
  set {
    name  = "job_max_delay"
    value = var.extprod_job_max_delay
  }
  
  set {
    name  = "production_svc"
    value = var.production_svc
  }
}


############################################################
# INSTALL APP HELM CHART
############################################################
resource "helm_release" "app" {
  name       = "app"
  depends_on = [kubernetes_namespace.app]

  chart      = "./app_main/helm"
  
  namespace  = var.app_namespace
  
  set {
    name  = "registry"
    value = var.registry
  }
  
  set {
    name  = "adminfile_version"
    value = var.image_tag
  }
  
  set {
    name  = "orderfile_version"
    value = var.image_tag
  }
  
  set {
    name  = "order_version"
    value = var.image_tag
  }
  
  set {
    name  = "inventorydb_version"
    value = var.image_tag
  }
  
  set {
    name  = "payment_version"
    value = var.image_tag
  }
  
  set {
    name  = "initqueue_version"
    value = var.image_tag
  }
  
  set {
    name  = "orderprocessing_version"
    value = var.image_tag
  }
  
  set {
    name  = "notification_version"
    value = var.image_tag
  }
  
  set {
    name  = "prodrequest_version"
    value = var.image_tag
  }
  
  set {
    name  = "production_version"
    value = var.image_tag
  }
  
  set {
    name  = "fulfilment_version"
    value = var.image_tag
  }
  
  set {
    name  = "appd_ext_version"
    value = var.image_tag
  }
  
  set {
    name  = "appd_dbagent_version"
    value = var.image_tag
  }

  set {
    name  = "appname"
    value = var.app_name
  }
  
  set {
    name  = "storageclass_name"
    value = var.storageclass_name
  }
  
  set {
    name  = "appd_account_name"
    value = var.appd_account_name
  }
  
  set {
    name  = "appd_username"
    value = var.appd_username
  }
  
  set {
    name  = "appd_password"
    value = var.appd_password
  }
  
  set {
    name  = "appd_controller_key"
    value = var.appd_controller_key
  }
  
  set {
    name  = "appd_controller_hostname"
    value = var.appd_controller_hostname
  }

  set {
    name  = "appd_controller_port"
    value = var.appd_controller_port
  }
  
  set {
    name  = "appd_controller_ssl"
    value = var.appd_controller_ssl
  }
  
  set {
    name  = "appd_global_account"
    value = var.appd_global_account
  }
  
  set {
    name  = "appd_browserapp_beaconurl"
    value = var.appd_browserapp_beaconurl
  }
  
  set {
    name  = "appd_browserapp_key"
    value = var.appd_browserapp_key
  }

  set {
    name  = "adminfile_name"
    value = var.adminfile_name
  }
  
  set {
    name  = "adminfile_appd"
    value = var.adminfile_appd
  }
  
  set {
    name  = "adminfile_tech"
    value = var.adminfile_tech
  }
  
  set {
    name  = "orderfile_name"
    value = var.orderfile_name
  }
  
  set {
    name  = "orderfile_appd"
    value = var.orderfile_appd
  }
  
  set {
    name  = "orderfile_tech"
    value = var.orderfile_tech
  }
  
  set {
    name  = "order_name"
    value = var.order_name
  }
  
  set {
    name  = "order_appd"
    value = var.order_appd
  }
  
  set {
    name  = "order_tech"
    value = var.order_tech
  }
  
  set {
    name  = "inventorydb_name"
    value = var.inventorydb_name
  }
  
  set {
    name  = "inventorydb_appd"
    value = var.inventorydb_appd
  }
  
  set {
    name  = "inventorydb_tech"
    value = var.inventorydb_tech
  }
  
  set {
    name  = "payment_name"
    value = var.payment_name
  }
  
  set {
    name  = "payment_appd"
    value = var.payment_appd
  }
  
  set {
    name  = "payment_tech"
    value = var.payment_tech
  }
  
  set {
    name  = "payment_min_random_delay"
    value = var.payment_min_random_delay
  }
  
  set {
    name  = "payment_max_random_delay"
    value = var.payment_max_random_delay
  }
  
  set {
    name  = "payment_lagspike_percentage"
    value = var.payment_lagspike_percentage
  }
  
  set {
    name  = "initqueue_name"
    value = var.initqueue_name
  }
  
  set {
    name  = "initqueue_tech"
    value = var.initqueue_tech
  }

  set {
    name  = "orderprocessing_name"
    value = var.orderprocessing_name
  }
  
  set {
    name  = "orderprocessing_appd"
    value = var.orderprocessing_appd
  }
  
  set {
    name  = "orderprocessing_tech"
    value = var.orderprocessing_tech
  }
  
  set {
    name  = "notification_name"
    value = var.notification_name
  }
  
  set {
    name  = "notification_appd"
    value = var.notification_appd
  }
  
  set {
    name  = "notification_tech"
    value = var.notification_tech
  }
  
  set {
    name  = "prodrequest_name"
    value = var.prodrequest_name
  }
  
  set {
    name  = "prodrequest_appd"
    value = var.prodrequest_appd
  }

  set {
    name  = "prodrequest_tech"
    value = var.prodrequest_tech
  }
  
  set {
    name  = "production_name"
    value = var.production_name
  }
  
  set {
    name  = "production_appd"
    value = var.production_appd
  }
  
  set {
    name  = "production_tech"
    value = var.production_tech
  }
  
  set {
    name  = "fulfilment_name"
    value = var.fulfilment_name
  }
  
  set {
    name  = "fulfilment_appd"
    value = var.fulfilment_appd
  }
  
  set {
    name  = "fulfilment_tech"
    value = var.fulfilment_tech
  }
  
  set {
    name  = "extpayment_svc"
    value = var.extpayment_svc
  }
  
  set {
    name  = "extprod_svc"
    value = var.extprod_svc
  }
  
  set {
    name  = "proxy_host"
    value = var.proxy_host
  }
  
  set {
    name  = "proxy_port"
    value = var.proxy_port
  }
}

############################################################
# INSTALL TRAFFICGENERATOR HELM CHART
############################################################
resource "helm_release" "trafficgen" {
  name       = "trafficgen"
  depends_on = [kubernetes_namespace.trafficgen,helm_release.app]

  chart      = "./trafficgen/helm"
  
  namespace  = var.trafficgen_namespace
  
  set {
    name  = "registry"
    value = var.registry
  }
  
  set {
    name  = "name"
    value = var.trafficgen_name
  }
  
  set {
    name  = "version"
    value = var.image_tag
  }
  
  set {
    name  = "app_endpoint"
    value = var.trafficgen_app_endpoint
  }
  
  set {
    name  = "replicas"
    value = var.trafficgen_replicas
  }
  
  set {
    name  = "min_random_delay"
    value = var.trafficgen_min_random_delay
  }
  
  set {
    name  = "max_random_delay"
    value = var.trafficgen_max_random_delay
  }
}
