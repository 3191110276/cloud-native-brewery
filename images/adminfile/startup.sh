#!/bin/bash

UNIQUE_HOST_ID=$(sed -rn '1s#.*/##; 1s/(.{12}).*/\\1/p' /proc/self/cgroup)
HOST=${HOSTNAME%%.*}

sed -i -e "s/APPD_APP_KEY/$BROWSERAPP_KEY/g" /usr/share/nginx/html/index.html
sed -i -e "s/HTTP_BEACON/$BROWSERAPP_BEACONURL/g" /usr/share/nginx/html/index.html
sed -i -e "s/HTTPS_BEACON/$BROWSERAPP_BEACONURL/g" /usr/share/nginx/html/index.html

sed -i -e "s/APPD_APP_KEY/$BROWSERAPP_KEY/g" /var/www/html/index.html
sed -i -e "s/HTTP_BEACON/$BROWSERAPP_BEACONURL/g" /var/www/html/index.html
sed -i -e "s/HTTPS_BEACON/$BROWSERAPP_BEACONURL/g" /var/www/html/index.html

nginx