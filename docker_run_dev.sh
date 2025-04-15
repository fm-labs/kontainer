#!/bin/bash

docker build -t kontainer:dev -f ./Dockerfile-alpine --progress=plain . && \

docker run -it --rm \
  --name kontainer-dev \
  -p 3080:3080 \
  -p 3443:3443 \
  -p 5000:5000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes:ro \
  -v kontainer_dev_data:/app/data \
  -e KONTAINER_DATA_VOLUME=kontainer_dev_data \
  kontainer:dev $@
