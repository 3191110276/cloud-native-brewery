#!/bin/bash

$MACHINE_AGENT_HOME/updateAnalyticsAgent.sh $MACHINE_AGENT_HOME

HOST=${HOSTNAME%%.*}


MA_PROPERTIES=${APPDYNAMICS_MA_PROPERTIES}
MA_PROPERTIES+=" -Dappdynamics.controller.hostName=${APPDYNAMICS_CONTROLLER_HOST_NAME}"
MA_PROPERTIES+=" -Dappdynamics.controller.port=${APPDYNAMICS_CONTROLLER_PORT}"
MA_PROPERTIES+=" -Dappdynamics.agent.accountName=${APPDYNAMICS_AGENT_ACCOUNT_NAME}"
MA_PROPERTIES+=" -Dappdynamics.agent.accountAccessKey=${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY}"
MA_PROPERTIES+=" -Dappdynamics.controller.ssl.enabled=${APPDYNAMICS_CONTROLLER_SSL_ENABLED}"
MA_PROPERTIES+=" -Dappdynamics.sim.enabled=${APPDYNAMICS_SIM_ENABLED} -Dappdynamics.docker.enabled=${APPDYNAMICS_DOCKER_ENABLED}"


MA_PROPERTIES+=" -Dappdynamics.docker.container.containerIdAsHostId.enabled=${APPDYNAMICS_AGENT_ENABLE_CONTAINERIDASHOSTID}"

if [ "x${APPDYNAMICS_MACHINE_HIERARCHY_PATH}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.machine.agent.hierarchyPath=SVM-${APPDYNAMICS_MACHINE_HIERARCHY_PATH}"
fi

if [ "x${APPDYNAMICS_AGENT_UNIQUE_HOST_ID}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.agent.uniqueHostId=${APPDYNAMICS_AGENT_UNIQUE_HOST_ID}"
fi

if [ "x${APPDYNAMICS_AGENT_PROXY_PORT}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.http.proxyHost=${APPDYNAMICS_AGENT_PROXY_HOST}"
fi

if [ "x${APPDYNAMICS_AGENT_PROXY_PORT}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.http.proxyPort=${APPDYNAMICS_AGENT_PROXY_PORT}"
fi

if [ "x${APPDYNAMICS_AGENT_PROXY_USER}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.http.proxyUser=${APPDYNAMICS_AGENT_PROXY_USER}"
fi

if [ "x${APPDYNAMICS_AGENT_PROXY_PASS}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.http.proxyPasswordFile=${APPDYNAMICS_AGENT_PROXY_PASS}"
fi



if [ "x${APPDYNAMICS_AGENT_METRIC_LIMIT}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.agent.maxMetrics=${APPDYNAMICS_AGENT_METRIC_LIMIT}"
fi


# Start background check
${MACHINE_AGENT_HOME}/check.sh &

# Start Machine Agent
${MACHINE_AGENT_HOME}/jre/bin/java ${MA_PROPERTIES} -jar ${MACHINE_AGENT_HOME}/machineagent.jar