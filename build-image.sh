#!/bin/bash

echo "Building multi-platform image..."
docker buildx build -t kontainer:latest \
  --sbom=true --provenance=true \
  --progress=plain \
  --platform linux/amd64,linux/arm64 \
  -f ./Dockerfile-alpine \
  .


if [ $1 = "--scan" ]; then
  echo "Scanning image for vulnerabilities"
  rm -rf build/
  mkdir -p build/
  docker scout cves kontainer:latest > build/scout-cves.txt
  docker scout recommendations kontainer:latest > build/scout-recommendations.txt
  exit 0
fi