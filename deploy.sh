#!/bin/bash
set -e

echo "=== Deploying Under Construction Page ==="

# Build and start container
docker compose up -d --build --force-recreate

# Clean up old images
docker image prune -f

echo "=== Deploy complete! Running on port 4004 ==="
