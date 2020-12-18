FROM openjdk:15-jdk-buster


ARG APPD_USER
ARG APPD_PW


RUN apt -y update

RUN apt -y install git jq


WORKDIR /appdynamics/java-agent/

COPY download.sh download.sh

RUN chmod 744 download.sh

RUN ./download.sh

RUN rm ./download.sh


WORKDIR /app

COPY main.java main.java

RUN wget https://repo1.maven.org/maven2/com/rabbitmq/amqp-client/5.6.0/amqp-client-5.6.0.jar

RUN wget https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.jar

RUN wget https://repo1.maven.org/maven2/org/slf4j/slf4j-simple/1.7.25/slf4j-simple-1.7.25.jar

RUN wget https://repo1.maven.org/maven2/HTTPClient/HTTPClient/0.3-3/HTTPClient-0.3-3.jar

RUN wget https://repo1.maven.org/maven2/com/googlecode/json-simple/json-simple/1.1.1/json-simple-1.1.1.jar

RUN wget https://repo1.maven.org/maven2/com/appdynamics/agent/agent-api/20.6.0.30246/agent-api-20.6.0.30246.jar

ENV CP=.:amqp-client-5.6.0.jar:slf4j-api-1.7.25.jar:slf4j-simple-1.7.25.jar:HTTPClient-0.3-3.jar:json-simple-1.1.1.jar:agent-api-20.6.0.30246.jar

COPY startup.sh startup.sh

RUN chmod +x startup.sh


ENTRYPOINT ["./startup.sh"]