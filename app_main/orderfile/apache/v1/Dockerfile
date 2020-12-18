#FROM httpd:2.4.46-alpine
FROM httpd:2.4.46


ARG APPD_USER
ARG APPD_PW


# Add bash, curl, jq
#RUN apk update && apk add bash && apk add curl && apk add jq
RUN apt -y update && apt -y install ca-certificates curl jq


# Remove default index.html
RUN rm /usr/local/apache2/htdocs/index.html


# Add web files
ADD webpage /usr/local/apache2/htdocs


# Install Apache Agent
WORKDIR /opt
COPY download.sh download.sh
RUN ls
RUN chmod +x ./download.sh
RUN ./download.sh
RUN rm ./download.sh


# Add permissions to Apache agent
RUN chmod -R 755 /opt/appdynamics-sdk-native
RUN chmod 777 /opt/appdynamics-sdk-native/logs

# Install Apache agent
RUN /opt/appdynamics-sdk-native/install.sh


# Expose ports
EXPOSE 80 443


# Copy startup file
COPY startup.sh /opt/startup.sh
RUN chmod +x /opt/startup.sh


# Add env variables
ENV LANG=en_US.UTF-8
ENV LANGUAGE=$LANG
ENV LC_ALL=$LANG


# Add AppD conf
COPY appdynamics_agent.conf /usr/local/apache2/conf/appdynamics_agent.conf
RUN echo Include conf/appdynamics_agent.conf >> /usr/local/apache2/conf/httpd.conf


# Start container
ENTRYPOINT ["/opt/startup.sh"]
#CMD ["apachectl", "-D", "FOREGROUND"]