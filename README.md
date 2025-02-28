# kmc

The KaptainStack's Mission Control (KMC) is a web-based dashboard for managing and monitoring your Docker containers and stacks.

Aims to be the ultimate tool for developers and system administrators to manage their Docker stacks and containers.

## Quick Start

```bash
docker run -d \
  --name kmc \
  --restart always \
  --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes:ro \
  -v kmc_data:/app/data \
  -p 13080:80 \
  fmlabs/kmc:latest
```

The KMC will be available at `http://localhost:13080`.


### Quick-Run Script

```bash
./run.sh
```

```bash
# Use curl to download this script and run it with bash
curl -fsSL https://raw.githubusercontent.com/fm-labs/kstack-mc/refs/heads/main/run.sh | bash
```

```bash
# Use wget to download this script and run it with bash
wget -qO- https://raw.githubusercontent.com/fm-labs/kstack-mc/refs/heads/main/run.sh | bash
```
