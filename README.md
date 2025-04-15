# kontainer

Manage multiple remote Docker daemons from a single web interface.


## Quick Start

Pull the latest image from Docker Hub and run it:

```bash
docker pull fmlabs/kontainer:latest
```

```bash
docker run -d \
  --name kontainer \
  --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes:ro \
  -v kontainer_data:/app/data \
  -p 3443:3443 \
  fmlabs/kontainer:latest
```

The web interface will be available at `https://localhost:3443`


### Quick-Run Script

Use the `run.sh` script to quickly run the KMC container.

```bash
#!/bin/bash
# KMC quick-run script v1
# This script is used to quickly run the KMC container
DOCKER=$(which docker)
KMC_CONTAINER_NAME=${KMC_CONTAINER_NAME:-kontainer}
KMC_PORT=${KMC_PORT:-3443}
$DOCKER stop ${KMC_CONTAINER_NAME} && $DOCKER rm ${KMC_CONTAINER_NAME}
$DOCKER pull fmlabs/kontainer:latest && \
exec $DOCKER run -d \
  --name ${KMC_CONTAINER_NAME} \
  --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes:ro \
  -v kontainer_data:/app/data \
  -p ${KMC_PORT}:3443 \
  fmlabs/kontainer:latest

```

#### Use curl to download this script and run it with bash

```bash
# sudo apt install curl
# yum install curl
# dnf install curl
curl -fsSL https://raw.githubusercontent.com/fm-labs/kontainer/refs/heads/main/run.sh | bash
```

#### Use wget to download this script and run it with bash

```bash
# sudo apt install wget
# yum install wget
# dnf install wget
wget -qO- https://raw.githubusercontent.com/fm-labs/kontainer/refs/heads/main/run.sh | bash
```
