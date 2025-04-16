#!/bin/bash
# KONTAINER quick-run script
# This script is used to quickly run the KONTAINER container
set -xe
DOCKER=$(which docker)
DOCKER_HOME=${DOCKER_HOME:-/var/lib/docker}
DOCKER_SOCKET=${DOCKER_SOCKET:-/var/run/docker.sock}
KONTAINER_IMAGE=${KONTAINER_IMAGE:-fmlabs/kontainer:latest}
KONTAINER_CONTAINER_NAME=${KONTAINER_CONTAINER_NAME:-kontainer}
KONTAINER_PORT=${KONTAINER_PORT:-3443}

echo "KONTAINER quick-run script"
echo "DOCKER=${DOCKER}"
echo "DOCKER_HOME=${DOCKER_HOME}"
echo "DOCKER_SOCKET=${DOCKER_SOCKET}"
echo "KONTAINER_IMAGE=${KONTAINER_IMAGE}"
echo "KONTAINER_CONTAINER_NAME=${KONTAINER_CONTAINER_NAME}"
echo "KONTAINER_PORT=${KONTAINER_PORT}"

$DOCKER stop ${KONTAINER_CONTAINER_NAME} && $DOCKER rm ${KONTAINER_CONTAINER_NAME}
$DOCKER pull ${KONTAINER_IMAGE} && \
exec $DOCKER run -d \
  --name ${KONTAINER_CONTAINER_NAME} \
  --restart always \
  -p ${KONTAINER_PORT}:3443 \
  -v ${DOCKER_SOCKET}:/var/run/docker.sock:ro \
  -v ${DOCKER_HOME}/volumes:/var/lib/docker/volumes:ro \
  -v kontainer_data:/app/data \
  -e KONTAINER_DATA_VOLUME=kontainer_data \
  -e DOCKER_HOME=${DOCKER_HOME} \
  ${KONTAINER_IMAGE}
