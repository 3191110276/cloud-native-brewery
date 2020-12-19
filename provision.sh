#!/bin/bash

helm install extprod ./app_extprod/helm/ -n automation --create-namespace
helm install extpayment ./app_extpayment/helm/ -n automation --create-namespace
helm install trafficgen ./trafficgen/helm/ -n trafficgen --create-namespace
helm install appd ./appdynamics/helm/ -n appdynamics --create-namespace
helm install iwo ./iwo/helm/ -n iwo --create-namespace
helm install stealthwatch ./stealthwatch_cloud/helm/ -n swc --create-namespace
helm install app ./app_main/helm/ -n default --create-namespace