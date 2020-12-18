#!/bin/bash

UNIQUE_HOST_ID=$(sed -rn '1s#.*/##; 1s/(.{12}).*/\\1/p' /proc/self/cgroup)
HOST=${HOSTNAME%%.*}

sed -i -e "s/CONTROLLER_HOST/$CONTROLLER_HOST/g" /usr/local/apache2/conf/appdynamics_agent.conf
sed -i -e "s/CONTROLLER_PORT/$CONTROLLER_PORT/g" /usr/local/apache2/conf/appdynamics_agent.conf
sed -i -e "s/ACCOUNT_NAME/$ACCOUNT_NAME/g" /usr/local/apache2/conf/appdynamics_agent.conf
sed -i -e "s/ACCESS_KEY/$ACCESS_KEY/g" /usr/local/apache2/conf/appdynamics_agent.conf
sed -i -e "s/HOSTNAME/$HOSTNAME/g" /usr/local/apache2/conf/appdynamics_agent.conf
sed -i -e "s/PROXY_URL/$PROXY_HOST/g" /usr/local/apache2/conf/appdynamics_agent.conf
sed -i -e "s/PROXY_PORT/$PROXY_PORT/g" /usr/local/apache2/conf/appdynamics_agent.conf

sed -i -e "s/APPD_APP_KEY/$BROWSERAPP_KEY/g" /usr/local/apache2/htdocs/index.html
sed -i -e "s/HTTP_BEACON/$BROWSERAPP_BEACONURL/g" /usr/local/apache2/htdocs/index.html
sed -i -e "s/HTTPS_BEACON/$BROWSERAPP_BEACONURL/g" /usr/local/apache2/htdocs/index.html

nohup /opt/appdynamics-sdk-native/runSDKProxy.sh >>/dev/null 2>/opt/appdynamics-sdk-native/logs/proxy.out &

apachectl -D FOREGROUND