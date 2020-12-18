#!/bin/bash

if [ "${PERSONALITY}" == "local-apache" ]; then
    mv /tmp/ApacheMonitor ${MACHINE_AGENT_HOME}monitors/
    TIER=FrontendUI
fi

if [ "${PERSONALITY}" == "local-nginx" ]; then
    mv /tmp/NginxMonitor ${MACHINE_AGENT_HOME}monitors/
    TIER=AdminUI
fi

if [ "${PERSONALITY}" == "local-activemq" ]; then
    mv /tmp/ActiveMQMonitor ${MACHINE_AGENT_HOME}monitors/
    TIER=ProdQueue
fi

HOST=${HOSTNAME%%.*}

MA_PROPERTIES="-Dappdynamics.controller.hostName=${CONTROLLER_HOST}"
MA_PROPERTIES+=" -Dappdynamics.controller.port=${CONTROLLER_PORT}"
MA_PROPERTIES+=" -Dappdynamics.controller.ssl.enabled=${CONTROLLER_SSL}"
MA_PROPERTIES+=" -Dappdynamics.agent.accountName=${ACCOUNT_NAME%%_*}" 
MA_PROPERTIES+=" -Dappdynamics.agent.accountAccessKey=${ACCESS_KEY}" 
MA_PROPERTIES+=" -Dappdynamics.agent.applicationName=${APP_NAME}"
MA_PROPERTIES+=" -Dappdynamics.agent.tierName=${TIER}"
MA_PROPERTIES+=" -Dappdynamics.agent.nodeName=${HOST}"

if [ "x${PROXY_HOST}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.http.proxyHost=${PROXY_HOST}"
    MA_PROPERTIES+=" -Dappdynamics.https.proxyHost=${PROXY_HOST}"
fi

if [ "x${PROXY_PORT}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.http.proxyPort=${PROXY_PORT}"
    MA_PROPERTIES+=" -Dappdynamics.https.proxyPort=${PROXY_PORT}"
fi

# Disable SIM and Docker Monitoring
MA_PROPERTIES+=" -Dappdynamics.sim.enabled=true -Dappdynamics.docker.enabled=false"

# Start Machine Agent
${MACHINE_AGENT_HOME}jre/bin/java ${MA_PROPERTIES} -jar ${MACHINE_AGENT_HOME}machineagent.jar