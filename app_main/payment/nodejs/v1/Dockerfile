# FROM node:14.15.0-alpine3.10
FROM node:10

#RUN apk update

#RUN apk add --no-cache bash

#RUN apk add --no-cache shadow

WORKDIR /app

COPY . .

RUN npm install

RUN npm install --appd_include_java_proxy=true appdynamics

RUN chmod +x startup.sh

EXPOSE 80

ENTRYPOINT ["/bin/bash", "./startup.sh"]