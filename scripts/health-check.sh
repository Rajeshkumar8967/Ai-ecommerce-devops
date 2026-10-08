#!/bin/bash

set -e

URL="http://localhost:8081"

echo "======================================"
echo "NEXVION Application Health Check"
echo "======================================"

if curl -fsS "$URL" > /dev/null; then
    echo "[HEALTHY] Application is responding at $URL"
else
    echo "[UNHEALTHY] Application is not responding at $URL"
    exit 1
fi
