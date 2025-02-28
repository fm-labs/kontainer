#!/bin/bash
# KMC quick-run script v1
# This script is used to quickly run the KMC container
DOCKER=$(which docker)
KMC_CONTAINER_NAME=${KMC_CONTAINER_NAME:-kmc}
KMC_PORT=${KMC_PORT:-3443}
$DOCKER stop ${KMC_CONTAINER_NAME} && $DOCKER rm ${KMC_CONTAINER_NAME}
$DOCKER pull fmlabs/kmc:latest && \
exec $DOCKER run -d \
  --name ${KMC_CONTAINER_NAME} \
  --restart always \
  --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes:ro \
  -v kmc_data:/app/data \
  -p ${KMC_PORT}:443 \
  fmlabs/kmc:latest
