# kontainer

Manage multiple remote Docker daemons from a single web interface.


## Quick Start

Pull the latest image from Docker Hub and run it:

```bash
#docker pull fmlabs/kontainer:latest
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

Use the `run.sh` script to quickly run KONTAINER.

```bash
#!/bin/bash
# KONTAINER quick-run script v1
# This script is used to quickly run the KONTAINER container
DOCKER=$(which docker)
KONTAINER_CONTAINER_NAME=${KONTAINER_CONTAINER_NAME:-kontainer}
KONTAINER_PORT=${KONTAINER_PORT:-3443}
$DOCKER stop ${KONTAINER_CONTAINER_NAME} && $DOCKER rm ${KONTAINER_CONTAINER_NAME}
$DOCKER pull fmlabs/kontainer:latest && \
exec $DOCKER run -d \
  --name ${KONTAINER_CONTAINER_NAME} \
  --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes:ro \
  -v kontainer_data:/app/data \
  -p ${KONTAINER_PORT}:3443 \
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

## Developer

### Update Dependencies

To update the `core` and `ui` submodules, run the following command:

```bash
./update_submodules.sh
```


### Run dev compose stack

```bash
./run-dev.sh up
# Use '/run-dev.sh down' to stop the stack
```

### Build Docker Image

```bash
./build-image.sh
```

### Scan Docker Image for Vulnerabilities

```bash
./build-image.sh --scan
```