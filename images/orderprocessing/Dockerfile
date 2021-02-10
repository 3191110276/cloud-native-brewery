FROM php:7.4-fpm

ARG APPD_USER
ARG APPD_PW

RUN apt -y update

RUN apt -y install git jq wget

WORKDIR /appdynamics/php-agent/

COPY download.sh download.sh

RUN chmod 744 download.sh

RUN ./download.sh

RUN rm ./download.sh

RUN chmod -R 755 /appdynamics/php-agent/appdynamics-php-agent-linux_x64/

RUN chmod 777 /appdynamics/php-agent/appdynamics-php-agent-linux_x64/logs


WORKDIR /app

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-install sockets

# Install RabbitMQ PHP client
RUN composer require php-amqplib/php-amqplib

RUN composer install

COPY index.php ./files/index.php

COPY index.php ./files/index.php

COPY msg_template.txt ./files/msg_template.txt

COPY startup.sh startup.sh

RUN chmod +x startup.sh

EXPOSE 80

ENV PHP_CLI_SERVER_WORKERS=4

ENTRYPOINT ["./startup.sh"]