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


# APACHE
RUN wget https://www.appdynamics.com/media/uploaded-files/1595827162/apachemonitor-2.0.3.zip

RUN unzip apachemonitor-2.0.3.zip

RUN rm apachemonitor-2.0.3.zip


# ACTIVEMQ
RUN wget https://www.appdynamics.com/media/uploaded-files/1589590186/activemqmonitor-v5.1.zip

RUN unzip activemqmonitor-v5.1.zip

RUN rm activemqmonitor-v5.1.zip


########################################################


FROM ubuntu:latest

# CREATE MACHINE AGENT FOLDER
ENV MACHINE_AGENT_HOME /opt/appdynamics/machine-agent/

RUN mkdir -p ${MACHINE_AGENT_HOME}


# SWITCH TO TMP DIRECTORY AND COPY FILES
WORKDIR "/tmp"

COPY --from=APPD_DOWNLOAD /appd ./


# MACHINE AGENT
RUN mv  -v ./machine-agent/* ${MACHINE_AGENT_HOME}


# NGINX
COPY ./nginx.yml ./NginxMonitor/config.yml


# APACHE
COPY ./apache.yml ./ApacheMonitor/config.yml


# ACTIVEMQ
COPY ./activemq.yml ./ActiveMQMonitor/config.yml


# ADD STARTUP SCRIPT
ADD start-appd.sh ${MACHINE_AGENT_HOME}

RUN chmod 744 ${MACHINE_AGENT_HOME}start-appd.sh


# CLEAN TMP
#RUN rm -r *


# STARTUP COMMAND
CMD "${MACHINE_AGENT_HOME}start-appd.sh"