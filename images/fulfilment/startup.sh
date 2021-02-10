#!/bin/bash

UNIQUE_HOST_ID=$(sed -rn '1s#.*/##; 1s/(.{12}).*/\\1/p' /proc/self/cgroup)
HOST=${HOSTNAME%%.*}

sed -i "s/NODENAME/$HOST/g" appd_config

pyagent run -c appd_config -- gunicorn --config gunicorn_config.py app.wsgi:app