#!/bin/bash

kubectl delete rabbitmqcluster brewery-orderqueue

helm uninstall extprod -n automation
helm uninstall extpayment -n ext
helm uninstall trafficgen -n trafficgen
helm uninstall iwo -n iwo
helm uninstall stealthwatch -n swc
helm uninstall app -n default
helm uninstall appd -n appdynamics

kubectl delete ns automation --wait=False
kubectl delete ns ext --wait=False
kubectl delete ns trafficgen --wait=False
kubectl delete ns iwo --wait=False
kubectl delete ns swc --wait=False
kubectl delete ns appdynamics --wait=False