#!/bin/bash

QUERY='{"username": "'$APPD_USER'","password": "'$APPD_PW'","scopes": ["download"]}'

TOKEN=$(curl -X POST https://identity.msrv.saas.appdynamics.com/v2.0/oauth/token -d "$QUERY" | jq -r '.access_token')

AUTH=$(echo "Authorization: Bearer $TOKEN");

curl -L -O -H "$AUTH" https://download.appdynamics.com/download/prox/download-file/java-jdk8/20.10.0.31173/AppServerAgent-1.8-20.10.0.31173.zip

unzip AppServerAgent-1.8-20.10.0.31173.zip

rm AppServerAgent-1.8-20.10.0.31173.zip