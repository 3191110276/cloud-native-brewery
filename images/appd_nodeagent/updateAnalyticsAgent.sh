ANALYTICS_AGENT_PROPERTIES="${1}/monitors/analytics-agent/conf/analytics-agent.properties"
ANALYTICS_AGENT_CONFIG="${1}/monitors/analytics-agent/monitor.xml"

replaceText () {

	sed -i "s|$1|$2|g" $3
}

if [ "${APPDYNAMICS_AGENT_GLOBAL_ACCOUNT_NAME}" == "x" ] || [ "${EVENT_ENDPOINT}" == "x" ]; then
	echo "Missing at least one of the required parameters (EVENT_ENDPOINT, APPDYNAMICS_AGENT_GLOBAL_ACCOUNT_NAME). The Analytics Agent will be disabled"
    exit 0
fi

sed -i 's/false/true/g' $ANALYTICS_AGENT_CONFIG

PROTOCOL="http"

if [ "${APPDYNAMICS_CONTROLLER_SSL_ENABLED}" = "true" ]; then
    PROTOCOL="https"
fi

if [ "x${APPDYNAMICS_AGENT_APPLICATION_NAME}" != "x" ]; then
    replaceText 'ad.agent.name=analytics-agent1' "ad.agent.name=analytics-${APPDYNAMICS_AGENT_APPLICATION_NAME}" $ANALYTICS_AGENT_PROPERTIES
fi


replaceText 'ad.controller.url=http://localhost:8090' "ad.controller.url=$PROTOCOL://${APPDYNAMICS_CONTROLLER_HOST_NAME}:${APPDYNAMICS_CONTROLLER_PORT}" $ANALYTICS_AGENT_PROPERTIES

replaceText 'http.event.endpoint=http://localhost:9080' "http.event.endpoint=${EVENT_ENDPOINT}" $ANALYTICS_AGENT_PROPERTIES

replaceText 'http.event.name=customer1' "http.event.name=${APPDYNAMICS_AGENT_ACCOUNT_NAME}" $ANALYTICS_AGENT_PROPERTIES

replaceText 'http.event.accountName=analytics-customer1' "http.event.accountName=${APPDYNAMICS_AGENT_GLOBAL_ACCOUNT_NAME}" $ANALYTICS_AGENT_PROPERTIES

replaceText 'http.event.accessKey=your-account-access-key' "http.event.accessKey=${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY}" $ANALYTICS_AGENT_PROPERTIES

if [ "x${APPDYNAMICS_AGENT_PROXY_HOST}" != "x" ]; then
    replaceText 'http.event.proxyHost=' "http.event.proxyHost=${APPDYNAMICS_AGENT_PROXY_HOST}" $ANALYTICS_AGENT_PROPERTIES
fi

if [ "x${APPDYNAMICS_AGENT_PROXY_PORT}" != "x" ]; then
    replaceText 'http.event.proxyPort=' "http.event.proxyPort=${APPDYNAMICS_AGENT_PROXY_PORT}" $ANALYTICS_AGENT_PROPERTIES
fi

if [ "x${APPDYNAMICS_AGENT_PROXY_USER}" != "x" ]; then
    replaceText 'http.event.proxyUsername=' "http.event.proxyUsername=${APPDYNAMICS_AGENT_PROXY_USER}" $ANALYTICS_AGENT_PROPERTIES
fi

if [ "x${APPDYNAMICS_AGENT_PROXY_PASS}" != "x" ]; then
    replaceText 'http.event.proxyPassword=' "http.event.proxyPassword=${APPDYNAMICS_AGENT_PROXY_PASS}" $ANALYTICS_AGENT_PROPERTIES
fi