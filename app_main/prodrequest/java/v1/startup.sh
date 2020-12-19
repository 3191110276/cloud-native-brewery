#!/bin/bash

UNIQUE_HOST_ID=$(sed -rn '1s#.*/##; 1s/(.{12}).*/\\1/p' /proc/self/cgroup)
HOST=${HOSTNAME%%.*}


MA_PROPERTIES="-Dappdynamics.controller.hostName=${CONTROLLER_HOST}"
MA_PROPERTIES+=" -Dappdynamics.controller.port=${CONTROLLER_PORT}"
MA_PROPERTIES+=" -Dappdynamics.controller.ssl.enabled=${CONTROLLER_SSL}"
MA_PROPERTIES+=" -Dappdynamics.agent.accountName=${ACCOUNT_NAME%%_*}" 
MA_PROPERTIES+=" -Dappdynamics.agent.accountAccessKey=${ACCESS_KEY}" 
MA_PROPERTIES+=" -Dappdynamics.agent.applicationName=brewery"
MA_PROPERTIES+=" -Dappdynamics.agent.tierName=ProdReuqest"
#MA_PROPERTIES+=" -Dappdynamics.agent.applicationName=${APPD_APP_NAME}"
#MA_PROPERTIES+=" -Dappdynamics.agent.tierName=${APPD_TIER_NAME}"
MA_PROPERTIES+=" -Dappdynamics.agent.nodeName=${HOST}"

if [ "x${PROXY_HOST}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.http.proxyHost=${PROXY_HOST}"
    MA_PROPERTIES+=" -Dappdynamics.https.proxyHost=${PROXY_HOST}"
fi

if [ "x${PROXY_PORT}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.http.proxyPort=${PROXY_PORT}"
    MA_PROPERTIES+=" -Dappdynamics.https.proxyPort=${PROXY_PORT}"
fi

#MA_PROPERTIES+=" -Dappdynamics.docker.enabled=false"

java -cp $CP -javaagent:/appdynamics/java-agent/javaagent.jar ${MA_PROPERTIES} main.java