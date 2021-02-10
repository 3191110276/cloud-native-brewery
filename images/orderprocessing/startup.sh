#!/bin/bash

UNIQUE_HOST_ID=$(sed -rn '1s#.*/##; 1s/(.{12}).*/\\1/p' /proc/self/cgroup)
HOST=${HOSTNAME%%.*}

/appdynamics/php-agent/appdynamics-php-agent-linux_x64/install.sh -s -a=${ACCOUNT_NAME}@${ACCESS_KEY} --http-proxy-host=${PROXY_HOST} --http-proxy-port=${PROXY_PORT} ${CONTROLLER_HOST} ${CONTROLLER_PORT} ${APPD_APP_NAME} ${APPD_TIER_NAME} ${HOSTNAME}

cd ./files

php -S 0.0.0.0:80