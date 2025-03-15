#!/bin/bash
# KMC quick-run script v1
# This script is used to quickly run the KMC container
DOCKER=$(which docker)
DOCKER_HOME=${DOCKER_HOME:-/var/lib/docker}
DOCKER_SOCKET=${DOCKER_SOCKET:-/var/run/docker.sock}
KMC_CONTAINER_NAME=${KMC_CONTAINER_NAME:-kmc}
KMC_PORT=${KMC_PORT:-3443}

echo "KMC quick-run script v1"
echo "DOCKER=${DOCKER}"
echo "DOCKER_HOME=${DOCKER_HOME}"
echo "KMC_CONTAINER_NAME=${KMC_CONTAINER_NAME}"
echo "KMC_PORT=${KMC_PORT}"

$DOCKER stop ${KMC_CONTAINER_NAME} && $DOCKER rm ${KMC_CONTAINER_NAME}
$DOCKER pull fmlabs/kmc:latest && \
exec $DOCKER run -d \
  --name ${KMC_CONTAINER_NAME} \
  --restart always \
  -v ${DOCKER_SOCKET}:/var/run/docker.sock:ro \
  -v ${DOCKER_HOME}/volumes:/var/lib/docker/volumes:ro \
  -v kmc_data:/app/data \
  -p ${KMC_PORT}:3443 \
  fmlabs/kmc:latest
