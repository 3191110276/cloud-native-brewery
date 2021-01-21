#!/bin/bash

POD=$(kubectl get pod -n iwo | grep iwo | awk '{print $1}')

kubectl -n iwo exec -it $POD -- curl -X PUT http://localhost:9110/HttpProxies -d '{"ProxyType":"Manual", "ProxyHost":"proxy-wsa.esl.cisco.com", "ProxyPort":80}'

TOKEN=$(kubectl -n iwo exec -it $POD -- curl -s http://localhost:9110/SecurityTokens | jq '.[].Token')
ID=$(kubectl -n iwo exec -it $POD -- curl -s http://localhost:9110/DeviceIdentifiers | jq '.[].Id')