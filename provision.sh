#!/bin/bash

helm install hxcsi ./hx_csi/helm/ -n hx --create-namespace
sleep 2s

helm install appd ./appdynamics/helm/ -n appdynamics --create-namespace
sleep 10s

helm install observability ./observability/helm/ -n observability --create-namespace
sleep 10s

helm install extpayment ./app_extpayment/helm/ -n ext --create-namespace
sleep 10s

helm install extprod ./app_extprod/helm/ -n automation --create-namespace
sleep 10s

helm install iwo ./iwo/helm/ -n iwo --create-namespace
sleep 10s

helm install stealthwatch ./stealthwatch_cloud/helm/ -n swc --create-namespace
sleep 10s

helm install app ./app_main/helm/ -n app --create-namespace
sleep 20s

helm install trafficgen ./trafficgen/helm/ -n trafficgen --create-namespace