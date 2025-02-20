#!/bin/bash

docker build -t kmc:dev -f ./Dockerfile --progress=plain . && \

docker run -it --rm \
  --name kmc-dev \
  --privileged \
  -p 15080:80 \
  -p 15000:5000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes:ro \
  -v kmc_dev_data:/app/data \
  kmc:dev $@
