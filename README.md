# kaptainstack a.k.a kstack

Just another software stack for managing docker containers.

**Under active development**


## Quick Start

```bash
docker run -d \
  --name kstack \
  --restart always \
  --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes:ro \
  -v kstack_data:/app/data \
  -p 5000:5000 \
  fmlabs/kstack:latest
```