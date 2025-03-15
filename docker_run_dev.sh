#!/bin/bash

mkdir -p .dev/ssl

if [[ ! -f .dev/ssl/self-signed.crt ]]; then
  echo "Generating self-signed certificate ..."
  openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout .dev/ssl/self-signed.key -out .dev/ssl/self-signed.crt -subj '/CN=localhost'
  RC=$?
  if [[ $RC != 0 ]]; then
    echo "ERROR: Failed to generate self-signed certificate"
    exit 1
  fi
fi

if [[ ! -f .dev/ssl/dhparam.pem ]]; then
  echo "Generating dhparam.pem ..."
  openssl dhparam -out .dev/ssl/dhparam.pem 2048
  RC=$?
  if [[ $RC != 0 ]]; then
    echo "ERROR: Failed to generate dhparam.pem"
    exit 1
  fi
fi

docker build -t kmc:dev -f ./Dockerfile-alpine --progress=plain . && \

docker run -it --rm \
  --name kmc-dev \
  -p 3080:3080 \
  -p 3443:3443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes:ro \
  -v kmc_dev_data:/app/data \
  -v $PWD/.dev/ssl:/app/ssl \
  -e AGENT_DATA_VOLUME=kmc_dev_data \
  kmc:dev $@
