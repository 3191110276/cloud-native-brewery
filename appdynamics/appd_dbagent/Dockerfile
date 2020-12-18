FROM ubuntu:latest AS APPD_DOWNLOAD

ARG APPD_USER
ARG APPD_PW

RUN apt-get update
RUN apt-get install -y jq curl wget unzip

WORKDIR /appd


# DB AGENT
COPY ./download.sh ./download.sh

RUN chmod 744 ./download.sh

RUN ./download.sh

RUN rm download.sh


########################################################


FROM openjdk:8-jre-slim

# CREATE DB AGENT FOLDER
ENV DB_AGENT_HOME /opt/appdynamics/db-agent/

RUN mkdir -p ${DB_AGENT_HOME}


# SWITCH TO TMP DIRECTORY AND COPY FILES
WORKDIR "/tmp"

COPY --from=APPD_DOWNLOAD /appd ./


# DB AGENT
RUN mv  -v ./db-agent/* ${DB_AGENT_HOME}


# ADD STARTUP SCRIPT
ADD start-appd.sh ${DB_AGENT_HOME}

RUN chmod 744 ${DB_AGENT_HOME}start-appd.sh


# CLEAN TMP
RUN rm -r *


# STARTUP COMMAND
CMD "${DB_AGENT_HOME}start-appd.sh"