#!/bin/bash

helm uninstall extprod -n automation
helm uninstall extpayment -n ext
helm uninstall trafficgen -n trafficgen
helm uninstall iwo -n iwo
helm uninstall stealthwatch -n swc
helm uninstall app -n app
helm uninstall observability -n observability
helm uninstall appd -n appdynamics
helm uninstall hxcsi -n hx


kubectl delete ns automation --wait=False
kubectl delete ns ext --wait=False
kubectl delete ns trafficgen --wait=False
kubectl delete ns iwo --wait=False
kubectl delete ns swc --wait=False
kubectl delete ns app --wait=False
kubectl delete ns observability --wait=False
kubectl delete ns appdynamics --wait=False
kubectl delete ns hx --wait=False