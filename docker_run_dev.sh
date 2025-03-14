#!/bin/bash

docker build -t kmc:dev -f ./Dockerfile-alpine --progress=plain . && \

docker run -it --rm \
  --name kmc-dev \
  --privileged \
  -p 3080:80 \
  -p 3443:443 \
  -p 5000:5000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes:ro \
  -v kmc_dev_data:/app/data \
  kmc:dev $@
