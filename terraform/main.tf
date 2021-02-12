############################################################
# 1) SETUP ACI NETWORKING
############################################################
# ????

############################################################
# 2) DEPLOY CLUSTERS
############################################################
# On-prem Cluster A
# On-prem Cluster B
# Cloud Cluster A (AWS)
# Cloud Cluser B (Azure)

############################################################
# 3) INSTALL HX CSI
############################################################
# Set up HX CSI on all deployed on-prem Clusters

############################################################
# 4) CONFIGURE SERVICE MESH
############################################################
# Set up Consul on all deployed Clusters

############################################################
# 5) DEPLOY APPD
############################################################
# Deploy AppD Cluster Agent on all deployed Clusters
# Deploy AppD DB Collector on all clusters with DBs

############################################################
# 6) DEPLOY IWO
############################################################
# Deploy IWO Connector on all deployed Clusters

############################################################
# 7) DEPLOY THOUSANDEYES
############################################################
# ????

############################################################
# 8) DEPLOY APP COMPONENTS
############################################################
# Deploy app components on one or multiple clusters
# Deploy AppD app agents
# Deploy argento app agents

############################################################
# 9) DEPLOY TRAFFICGEN
############################################################
# Deploy trafficgen, where????




###########################################################################
###########################################################################




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
#resource "appdynamics_eum_application" "main" {
#  name = "${var.app_name}_eum"
#  description = "Demo Application"
#  count      = var.brewery_deploy ? 1 : 0
#}

#output "eum" {
#  value = appdynamics_eum_application.main[0]
#}


############################################################
# INSTALL APPDYNAMICS
############################################################
module "appdynamics" {
  count      = var.appd_deploy ? 1 : 0
  depends_on = [kubernetes_namespace.appdynamics]
  
  source = "./modules/appdynamics/"
  
  app_name = var.app_name
  
  registry = var.registry
  image_tag = var.image_tag
  
  appd_namespace = var.appd_namespace
  
  appd_account_name = var.appd_account_name
  appd_username = var.appd_username
  appd_password = var.appd_password
  appd_controller_key = var.appd_controller_key
  appd_controller_protocol = var.appd_controller_protocol
  appd_controller_hostname = var.appd_controller_hostname
  appd_global_account = var.appd_global_account
  appd_controller_port = var.appd_controller_port
  appd_controller_ssl = var.appd_controller_ssl
  appd_browserapp_beaconurl = var.appd_browserapp_beaconurl
  appd_token = var.appd_token
  
  appd_ns_to_monitor = var.appd_ns_to_monitor
  
  proxy_url = var.proxy_url
  proxy_host = var.proxy_host
  proxy_port = var.proxy_port
}

module "appd_dbcollector" {
  count      = var.appd_deploy ? 1 : 0
  depends_on = [kubernetes_namespace.appdynamics]
  
  source = "./modules/appd_dbcollector/"
  
  app_name = var.app_name
  
  registry = var.registry
  image_tag = var.image_tag
  
  namespace = var.appd_namespace
  
  appd_account_name = var.appd_account_name
  #appd_username = var.appd_username
  #appd_password = var.appd_password
  appd_controller_key = var.appd_controller_key
  #appd_controller_protocol = var.appd_controller_protocol
  appd_controller_hostname = var.appd_controller_hostname
  #appd_global_account = var.appd_global_account
  #appd_controller_port = var.appd_controller_port
  appd_controller_ssl = var.appd_controller_ssl
  #appd_browserapp_beaconurl = var.appd_browserapp_beaconurl
  #appd_token = var.appd_token
  
  #appd_ns_to_monitor = var.appd_ns_to_monitor
  
  #proxy_url = var.proxy_url
  #proxy_host = var.proxy_host
  #proxy_port = var.proxy_port
}


############################################################
# CREATE DB COLLECTOR IN APPD
############################################################
resource "appdynamics_db_collector" "main" {
  depends_on = [module.appdynamics]
  name = "${var.app_name} DB"
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
module "observability" {
  count      = var.observability_deploy ? 1 : 0
  depends_on = [kubernetes_namespace.observability]
  
  source = "./modules/observability/"

  namespace = var.observability_namespace
}


############################################################
# INSTALL EXTPAYMENT
############################################################
module "extpayment" {
  count      = var.brewery_deploy ? 1 : 0
  depends_on = [kubernetes_namespace.extpayment]
  
  source = "./modules/app_extpayment/"
  
  namespace = var.extpayment_namespace
  
  registry = var.registry
  image_tag = var.image_tag
  extpayment_tech = var.extpayment_tech
  
  extpayment_name = var.extpayment_name
  
  extpayment_replicas = var.extpayment_replicas
  
  extpayment_min_random_delay = var.extpayment_min_random_delay
  extpayment_max_random_delay = var.extpayment_max_random_delay
  extpayment_lagspike_percentage = var.extpayment_lagspike_percentage
}


############################################################
# INSTALL EXTPROD
############################################################
module "extprod" {
  count      = var.brewery_deploy ? 1 : 0
  depends_on = [kubernetes_namespace.extprod]
  
  source = "./modules/app_extprod/"
  
  namespace = var.extprod_namespace
  
  registry = var.registry
  image_tag = var.image_tag
  extprod_tech = var.extprod_tech
  
  extprod_name = var.extprod_name
  
  extprod_replicas = var.extprod_replicas
  
  extprod_min_delay = var.extprod_min_delay
  extprod_max_delay = var.extprod_max_delay
  
  extprod_job_min_delay = var.extprod_job_min_delay
  extprod_job_max_delay = var.extprod_job_max_delay
  
  production_svc = var.production_svc
}


############################################################
# INSTALL APP
############################################################
resource "helm_release" "app" {
  name       = "app"
  depends_on = [kubernetes_namespace.app,appdynamics_apm_application.main]#,appdynamics_eum_application.main]
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
    value = "AA-AAA-AAA" #appdynamics_eum_application.main[0].eum_key
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
# INSTALL TRAFFICGENERATOR
############################################################
module "trafficgen" {
  depends_on = [kubernetes_namespace.trafficgen,helm_release.app]
  count      = var.brewery_deploy ? 1 : 0
  
  source = "./modules/app_trafficgen/"

  namespace = var.trafficgen_namespace
  
  registry = var.registry
  image_tag = var.image_tag
  
  trafficgen_name = var.trafficgen_name
  trafficgen_replicas = var.trafficgen_replicas
  
  trafficgen_min_random_delay = var.trafficgen_min_random_delay
  trafficgen_max_random_delay = var.trafficgen_max_random_delay
  
  trafficgen_app_endpoint = var.trafficgen_app_endpoint
}


############################################################
# INSTALL IWO
############################################################
module "iwo" {
  depends_on = [kubernetes_namespace.iwo]
  count      = var.iwo_deploy ? 1 : 0
  
  source = "./modules/iwo/"

  namespace = var.iwo_namespace
}


############################################################
# INSTALL HX-CSI
############################################################
module "hxcsi" {
  depends_on = [kubernetes_namespace.hxcsi]
  count      = var.hxcsi_deploy ? 1 : 0
  
  source = "./modules/hx_csi/"

  namespace = var.hxcsi_namespace
}


############################################################
# INSTALL STEALTHWATCH
############################################################
module "swc" {
  count      = var.stealthwatch_deploy ? 1 : 0
  depends_on = [kubernetes_namespace.stealthwatch]
  
  source = "./modules/stealthwatch_cloud/"

  namespace = var.stealthwatch_namespace
  
  stealthwatch_service_key = var.stealthwatch_service_key
}


############################################################
# INSTALL CLUSTERLOAD APP
############################################################
module "clusterload" {
  count      = var.clusterload_deploy ? 1 : 0
  depends_on = [kubernetes_namespace.clusterload]
  
  source = "./modules/clusterload/"

  namespace = var.clusterload_namespace
  
  clusterload_quota_pods = var.clusterload_quota_pods
  clusterload_quota_cpu_request = var.clusterload_quota_cpu_request
  clusterload_quota_cpu_limit = var.clusterload_quota_cpu_limit
  clusterload_quota_memory_request = var.clusterload_quota_memory_request
  clusterload_quota_memory_limit = var.clusterload_quota_memory_limit
  clusterload_configurtions = var.clusterload_configurtions
}


############################################################
# INSTALL WORLD APP
############################################################
module "world" {
  count      = var.world_deploy ? 1 : 0
  depends_on = [kubernetes_namespace.world]
  
  source = "./modules/world/"

  namespace = var.world_namespace
}


############################################################
# INSTALL CONSUL
############################################################
module "consul" {
  count      = var.mesh_deploy ? 1 : 0
  depends_on = [kubernetes_namespace.mesh]
  
  source = "./modules/consul/"

  namespace = var.mesh_namespace 
}