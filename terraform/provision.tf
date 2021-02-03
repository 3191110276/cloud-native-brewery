############################################################
# CREATE APM APP IN APPD
############################################################
resource "appdynamics_apm_application" "main" {
  name = var.app_name
  description = "Demo Application"
  count      = var.brewery_deploy ? 1 : 0
}


############################################################
# CREATE EUM APP IN APPD
############################################################
resource "appdynamics_eum_application" "main" {
  name = "${var.app_name}_eum"
  description = "Demo Application"
  count      = var.brewery_deploy ? 1 : 0
}

output "eum" {
  value = appdynamics_eum_application.main[0]
}


############################################################
# INSTALL HX-CSI HELM CHART
############################################################
resource "helm_release" "hxcsi" {
  name       = "hxcsi"
  depends_on = [kubernetes_namespace.hxcsi]
  count      = var.hxcsi_deploy ? 1 : 0

  chart      = "../hx_csi/helm"
  
  namespace  = var.hxcsi_namespace
}


############################################################
# INSTALL APPDYNAMICS HELM CHART
############################################################
resource "helm_release" "appdynamics" {
  name       = "appd"
  depends_on = [kubernetes_namespace.appdynamics]
  count      = var.appd_deploy ? 1 : 0

  chart      = "../appdynamics/helm"
  
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
# CREATE DB COLLECTOR IN APPD
############################################################
resource "appdynamics_db_collector" "main" {
  depends_on = [helm_release.appdynamics]
  name = "Inventory DB"
  type = "MYSQL"
  hostname = "${var.app_name}-inventorydb-service.${var.app_namespace}"
  port = "80"
  username = "root"
  password = "root"
  agent_name = var.app_name
}


############################################################
# GET TOKEN FOR IWO CLAIM
############################################################
#data "external" "iwo_token" {
#  depends_on = [kubernetes_deployment.iwok8scollector]
#  program = ["bash", "../iwo/register.sh"]
#  query = {
#    proxy_host = var.proxy_host
#    proxy_port = var.proxy_port
#  }
#}

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
  count      = var.observability_deploy ? 1 : 0

  chart      = "../observability/helm"
  
  namespace  = var.observability_namespace
}


############################################################
# INSTALL STEALTHWATCH HELM CHART
############################################################
resource "helm_release" "stealthwatch" {
  name       = "stealthwatch"
  depends_on = [kubernetes_namespace.stealthwatch]
  count      = var.stealthwatch_deploy ? 1 : 0

  chart      = "../stealthwatch_cloud/helm"
  
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
  count      = var.brewery_deploy ? 1 : 0

  chart      = "../app_extpayment/helm"
  
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
  count      = var.brewery_deploy ? 1 : 0

  chart      = "../app_extprod/helm"
  
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
  depends_on = [kubernetes_namespace.app,appdynamics_apm_application.main,appdynamics_eum_application.main]
  count      = var.brewery_deploy ? 1 : 0

  chart      = "../app_main/helm"
  
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
    name  = "orderprocessing_cpurequest"
    value = var.orderprocessing_cpurequest
  }
  
  set {
    name  = "orderprocessing_memrequest"
    value = var.orderprocessing_memrequest
  }
  
  set {
    name  = "orderprocessing_cpulimit"
    value = var.orderprocessing_cpulimit
  }
  
  set {
    name  = "orderprocessing_memlimit"
    value = var.orderprocessing_memlimit
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
    value = appdynamics_eum_application.main[0].eum_key
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
  count      = var.brewery_deploy ? 1 : 0

  chart      = "../trafficgen/helm"
  
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


############################################################
# INSTALL WORLD APP
############################################################
resource "helm_release" "world_app" {
  name       = "worldapp"
  depends_on = [kubernetes_namespace.world]
  count      = var.world_deploy ? 1 : 0

  chart      = "../world_app/world-app-helm"
  
  namespace  = var.world_namespace
}

