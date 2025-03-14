#!/bin/bash

echo "Pull latest base image..."
docker pull python:3.13-alpine

echo "Building multi-platform image..."
docker buildx build -t kmc:latest \
  --progress=plain \
  --platform linux/amd64,linux/arm64 \
  -f ./Dockerfile-alpine \
  .

echo "Scanning image for vulnerabilities"
docker scout cves kmc:latest
