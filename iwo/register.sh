#!/bin/bash

set -e

#eval "$(jq -r '@sh "FOO=\(.foo) BAZ=\(.baz)"')"

POD=$(kubectl get pod -n iwo | grep iwo | awk '{print $1}')

PROXY=$(kubectl -n iwo -c iwo-k8s-collector exec -it $POD -- curl -X PUT http://localhost:9110/HttpProxies -d '{"ProxyType":"Manual", "ProxyHost":"proxy-wsa.esl.cisco.com", "ProxyPort":80}')

TOKEN=$(kubectl -n iwo -c iwo-k8s-collector exec -it $POD -- curl -s http://localhost:9110/SecurityTokens | jq '.[].Token')
TOKEN=${TOKEN:1}
TOKEN=${TOKEN::-1}

ID=$(kubectl -n iwo -c iwo-k8s-collector exec -it $POD -- curl -s http://localhost:9110/DeviceIdentifiers | jq '.[].Id')
ID=${ID:1}
ID=${ID::-1}

jq -n --arg pod "$POD" --arg id "$ID" --arg token "$TOKEN" '{"pod":$pod, "id": $id, "token": $token}'