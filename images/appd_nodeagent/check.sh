#!/bin/bash

while true; do
    echo TESTING
    kubectl get pods -n default -l tier=adminfile -o wide | grep $HOSTNAME | awk '{print $6}' | while read line; do echo $line; done
    kubectl get pods -n default -l tier=orderfile -o wide | grep $HOSTNAME | awk '{print $6}' | while read line; do echo $line; done
    kubectl get pods -n default -l tier=orderqueue -o wide | grep $HOSTNAME | awk '{print $6}' | while read line; do echo $line; done
    sleep 10
done



#sed 's/IP/$line/g' nginx_template > nginx_update