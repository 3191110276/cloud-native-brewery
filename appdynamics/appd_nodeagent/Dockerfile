FROM ubuntu:latest AS APPD_DOWNLOAD

ARG APPD_USER
ARG APPD_PW

RUN apt-get update
RUN apt-get install -y jq curl wget unzip

WORKDIR /appd


# MACHINE AGENT
COPY ./download.sh ./download.sh

RUN chmod 744 ./download.sh

RUN ./download.sh

RUN rm download.sh


# NGINX
RUN wget https://www.appdynamics.com/media/uploaded-files/1602047578/nginxmonitor-2.2.0.zip

RUN unzip nginxmonitor-2.2.0.zip

RUN rm nginxmonitor-2.2.0.zip

RUN mv ./NginxMonitor ./machine-agent/monitors/

COPY ./nginx.yml ./machine-agent/NginxMonitor/config.yml


# APACHE
RUN wget https://www.appdynamics.com/media/uploaded-files/1595827162/apachemonitor-2.0.3.zip

RUN unzip apachemonitor-2.0.3.zip

RUN rm apachemonitor-2.0.3.zip

RUN mv ./ApacheMonitor ./machine-agent/monitors/

COPY ./apache.yml ./machine-agent/ApacheMonitor/config.yml


# ACTIVEMQ
RUN wget https://www.appdynamics.com/media/uploaded-files/1589590186/activemqmonitor-v5.1.zip

RUN unzip activemqmonitor-v5.1.zip

RUN rm activemqmonitor-v5.1.zip

RUN mv ./ActiveMQMonitor ./machine-agent/monitors/

COPY ./activemq.yml ./machine-agent/ActiveMQMonitor/config.yml


########################################################


FROM openjdk:8-jre-slim


RUN apt-get update -y; \
 apt-get install -y --no-install-recommends curl iproute2 procps dumb-init coreutils sed; \
	rm -rf /var/lib/apt/lists/*


# INSTALL KUBECTL
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.19.0/bin/linux/amd64/kubectl

RUN chmod +x ./kubectl

RUN mv ./kubectl /usr/local/bin/kubectl


# CREATE MACHINE AGENT FOLDER
ENV MACHINE_AGENT_HOME /opt/appdynamics/machine-agent

RUN mkdir -p ${MACHINE_AGENT_HOME}


# SWITCH TO TMP DIRECTORY AND COPY FILES
WORKDIR "/tmp"

COPY --from=APPD_DOWNLOAD /appd ./


# MACHINE AGENT
RUN mv  -v ./machine-agent/* ${MACHINE_AGENT_HOME}


# ADD STARTUP SCRIPT
ADD start-appd.sh ${MACHINE_AGENT_HOME}

RUN chmod 744 ${MACHINE_AGENT_HOME}/start-appd.sh


# ADD ANALYTICS AGENT UPDATE SCRIPT
COPY updateAnalyticsAgent.sh ${MACHINE_AGENT_HOME}/updateAnalyticsAgent.sh
RUN chmod +x ${MACHINE_AGENT_HOME}/updateAnalyticsAgent.sh


# ADD BACKGROUND CHECK SCRIPT
COPY check.sh ${MACHINE_AGENT_HOME}/check.sh
RUN chmod +x ${MACHINE_AGENT_HOME}/check.sh


EXPOSE 9090


# STARTUP COMMAND
CMD "${MACHINE_AGENT_HOME}/start-appd.sh"