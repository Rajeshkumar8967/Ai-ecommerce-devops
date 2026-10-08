#!/bin/bash

set -e

echo "======================================"
echo "Starting NEXVION E-Commerce Application"
echo "======================================"

PORT=8081

if lsof -i :"$PORT" >/dev/null 2>&1; then
    echo "[ERROR] Port $PORT is already in use."
    exit 1
fi

echo "[INFO] Starting HTTP server on port $PORT..."
echo "[INFO] Application URL: http://localhost:$PORT"
echo ""

python3 -m http.server "$PORT" --bind 0.0.0.0
