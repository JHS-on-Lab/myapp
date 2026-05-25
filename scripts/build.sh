#!/bin/bash
# scripts/build.sh
set -e
cd "$(dirname "$0")/../worker"
docker build -t worker:latest .
echo "build complete: worker:latest"