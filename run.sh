#!/bin/bash
# KMC quick-run script
# This script is used to quickly run the KMC container
set -xe
DOCKER=$(which docker)
DOCKER_HOME=${DOCKER_HOME:-/var/lib/docker}
DOCKER_SOCKET=${DOCKER_SOCKET:-/var/run/docker.sock}
KMC_IMAGE=${KMC_IMAGE:-fmlabs/kmc:latest}
KMC_CONTAINER_NAME=${KMC_CONTAINER_NAME:-kmc}
KMC_PORT=${KMC_PORT:-3443}

echo "KMC quick-run script"
echo "DOCKER=${DOCKER}"
echo "DOCKER_HOME=${DOCKER_HOME}"
echo "DOCKER_SOCKET=${DOCKER_SOCKET}"
echo "KMC_IMAGE=${KMC_IMAGE}"
echo "KMC_CONTAINER_NAME=${KMC_CONTAINER_NAME}"
echo "KMC_PORT=${KMC_PORT}"

$DOCKER stop ${KMC_CONTAINER_NAME} && $DOCKER rm ${KMC_CONTAINER_NAME}
$DOCKER pull ${KMC_IMAGE} && \
exec $DOCKER run -d \
  --name ${KMC_CONTAINER_NAME} \
  --restart always \
  -p ${KMC_PORT}:3443 \
  -v ${DOCKER_SOCKET}:/var/run/docker.sock:ro \
  -v ${DOCKER_HOME}/volumes:/var/lib/docker/volumes:ro \
  -v kstack_agent_data:/app/data \
  -e AGENT_DATA_VOLUME=kstack_agent_data \
  -e DOCKER_HOME=${DOCKER_HOME} \
  ${KMC_IMAGE}
