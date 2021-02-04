#!/bin/bash

QUERY='{"username": "'$APPD_USER'","password": "'$APPD_PW'","scopes": ["download"]}'

TOKEN=$(curl -X POST https://identity.msrv.saas.appdynamics.com/v2.0/oauth/token -d "$QUERY" | jq -r '.access_token')

AUTH=$(echo "Authorization: Bearer $TOKEN");

curl -L -O -H "$AUTH" https://download.appdynamics.com/download/prox/download-file/webserver-sdk/20.9.0.665.0/appdynamics-sdk-native-nativeWebServer-64bit-linux-20.9.0.665.0.tgz

tar zxvf appdynamics-sdk-native-nativeWebServer-64bit-linux-20.9.0.665.0.tgz -C /opt

rm appdynamics-sdk-native-nativeWebServer-64bit-linux-20.9.0.665.0.tgz
