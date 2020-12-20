#!/bin/bash

kubectl delete rabbitmqcluster brewery-orderqueue

helm uninstall extprod -n automation
helm uninstall extpayment -n ext
helm uninstall trafficgen -n trafficgen
helm uninstall iwo -n iwo
helm uninstall stealthwatch -n swc
helm uninstall app -n default
helm uninstall appd -n appdynamics

k delete ns automation --wait=False
k delete ns ext --wait=False
k delete ns trafficgen --wait=False
k delete ns iwo --wait=False
k delete ns swc --wait=False
k delete ns appdynamics --wait=False