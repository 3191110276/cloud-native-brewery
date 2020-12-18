#!/bin/bash

UNIQUE_HOST_ID=$(sed -rn '1s#.*/##; 1s/(.{12}).*/\\1/p' /proc/self/cgroup)
HOST=${HOSTNAME%%.*}


APPDYNAMICS_AGENT_REUSE_NODE_NAME_PREFIX=false
APPDYNAMICS_AGENT_NODE_NAME=${HOST%%.*}


node index.js 80 -Dappdynamics.dockerMonitoring=true