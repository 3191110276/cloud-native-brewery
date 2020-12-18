#!/bin/bash

QUERY='{"username": "'$APPD_USER'","password": "'$APPD_PW'","scopes": ["download"]}'

TOKEN=$(curl -X POST https://identity.msrv.saas.appdynamics.com/v2.0/oauth/token -d "$QUERY" | jq -r '.access_token')

AUTH=$(echo "Authorization: Bearer $TOKEN");

curl -L -O -H "$AUTH" https://download.appdynamics.com/download/prox/download-file/db-agent/20.9.0.1976/db-agent-20.9.0.1976.zip

unzip db-agent-20.9.0.1976.zip -d db-agent

rm db-agent-20.9.0.1976.zip