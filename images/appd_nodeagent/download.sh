#!/bin/bash

QUERY='{"username": "'$APPD_USER'","password": "'$APPD_PW'","scopes": ["download"]}'

TOKEN=$(curl -X POST https://identity.msrv.saas.appdynamics.com/v2.0/oauth/token -d "$QUERY" | jq -r '.access_token')

AUTH=$(echo "Authorization: Bearer $TOKEN");

curl -L -O -H "$AUTH" https://download.appdynamics.com/download/prox/download-file/machine-bundle/20.9.0.2763/machineagent-bundle-64bit-linux-20.9.0.2763.zip

unzip machineagent-bundle-64bit-linux-20.9.0.2763.zip -d machine-agent

rm machineagent-bundle-64bit-linux-20.9.0.2763.zip