#!/bin/bash

kubectl delete rabbitmqcluster brewery-orderqueue
helm uninstall app