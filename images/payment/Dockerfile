FROM node:10-slim

WORKDIR /app

COPY . .

RUN npm install \
    && npm install --appd_include_java_proxy=true appdynamics \
    && chmod +x startup.sh

EXPOSE 80

ENTRYPOINT ["/bin/bash", "./startup.sh"]
