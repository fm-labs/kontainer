#!/bin/bash

if [ -z "$SSH_AGENT_PID" ] || ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
    echo "Starting ssh-agent..."
    eval "$(ssh-agent -s)"
    echo "Adding default SSH key... "
    ssh-add ~/.ssh/id_rsa
else
    echo "SSH agent is already running."
    echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
    echo "SSH_AGENT_PID=$SSH_AGENT_PID"
fi

docker build -t kontainer:dev -f ./Dockerfile-alpine --progress=plain . && \

docker run -it --rm \
  --name kontainer-dev \
  -p 3080:3080 \
  -p 3443:3443 \
  -p 5000:5000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes:ro \
  -v kontainer_dev_data:/app/data \
  -v $SSH_AUTH_SOCK:/ssh-agent \
  -e SSH_AUTH_SOCK=/ssh-agent \
  -e KONTAINER_DATA_VOLUME=kontainer_dev_data \
  kontainer:dev $@
