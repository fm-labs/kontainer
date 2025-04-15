#!/bin/bash

echo "Pull latest base image..."
docker pull python:3.13-alpine

echo "Building multi-platform image..."
docker buildx build -t kontainer:latest \
  --progress=plain \
  --platform linux/amd64,linux/arm64 \
  -f ./Dockerfile-alpine \
  .

echo "Scanning image for vulnerabilities"
rm -rf build/
mkdir -p build/
docker scout cves kontainer:latest > build/scout-cves.txt
docker scout recommendations kontainer:latest > build/scout-recommendations.txt
