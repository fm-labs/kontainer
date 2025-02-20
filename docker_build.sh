#!/bin/bash


docker buildx build -t kmc:latest \
  --progress=plain \
  --platform linux/amd64,linux/arm64 \
  .