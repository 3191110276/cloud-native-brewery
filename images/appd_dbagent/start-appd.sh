#!/bin/bash

HOST=${HOSTNAME%%.*}

MA_PROPERTIES="-Dappdynamics.controller.hostName=${CONTROLLER_HOST}"
MA_PROPERTIES+=" -Dappdynamics.controller.port=${CONTROLLER_PORT}"
MA_PROPERTIES+=" -Dappdynamics.controller.ssl.enabled=${CONTROLLER_SSL}"
MA_PROPERTIES+=" -Dappdynamics.agent.accountName=${ACCOUNT_NAME%%_*}" 
MA_PROPERTIES+=" -Dappdynamics.agent.accountAccessKey=${ACCESS_KEY}" 
MA_PROPERTIES+=" -Dappdynamics.agent.applicationName=${APP_NAME}"

MA_PROPERTIES+=" -Ddbagent.name=${APP_NAME}"

if [ "x${PROXY_HOST}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.http.proxyHost=${PROXY_HOST}"
    MA_PROPERTIES+=" -Dappdynamics.https.proxyHost=${PROXY_HOST}"
fi

if [ "x${PROXY_PORT}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.http.proxyPort=${PROXY_PORT}"
    MA_PROPERTIES+=" -Dappdynamics.https.proxyPort=${PROXY_PORT}"
fi

# Disable SIM and Docker Monitoring
MA_PROPERTIES+=" -Dappdynamics.sim.enabled=false -Dappdynamics.docker.enabled=false"

java ${MA_PROPERTIES} -jar ${DB_AGENT_HOME}/db-agent.jar