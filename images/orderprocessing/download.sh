#!/bin/bash

QUERY='{"username": "'$APPD_USER'","password": "'$APPD_PW'","scopes": ["download"]}'

TOKEN=$(curl -X POST https://identity.msrv.saas.appdynamics.com/v2.0/oauth/token -d "$QUERY" | jq -r '.access_token')

AUTH=$(echo "Authorization: Bearer $TOKEN");

curl -L -O -H "$AUTH" https://download.appdynamics.com/download/prox/download-file/php-tar/20.10.0.4171/appdynamics-php-agent-x64-linux-20.10.0.4171.tar.bz2

tar -xvjf appdynamics-php-agent-x64-linux-20.10.0.4171.tar.bz2

rm appdynamics-php-agent-x64-linux-20.10.0.4171.tar.bz2