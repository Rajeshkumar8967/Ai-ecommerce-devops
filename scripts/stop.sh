#!/bin/bash

PORT=8081

echo "======================================"
echo "Stopping NEXVION E-Commerce Application"
echo "======================================"

PIDS=$(lsof -ti :"$PORT" 2>/dev/null || true)

if [ -z "$PIDS" ]; then
    echo "[INFO] No application running on port $PORT."
    exit 0
fi

echo "[INFO] Stopping process(es): $PIDS"

kill $PIDS

echo "[OK] Application stopped."
