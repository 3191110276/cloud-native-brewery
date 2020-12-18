FROM nginx:1.19.3-alpine
MAINTAINER Michael Maurer "mimaurer@cisco.com"


RUN apk update && apk add bash


# Overwrite default configugration
COPY ./nginx.conf /etc/nginx/nginx.conf


# Add web files
ADD webpage /usr/share/nginx/html/
ADD webpage /var/www/html/


# Copy startup file
COPY startup.sh startup.sh
RUN chmod +x startup.sh


# Expose ports
EXPOSE 80


# Startup command
ENTRYPOINT ["./startup.sh"]
#CMD ["nginx", "-g", "daemon off;"]