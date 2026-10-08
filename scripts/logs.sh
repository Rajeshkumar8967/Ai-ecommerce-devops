#!/bin/bash

LOG_FILE="logs/application.log"

echo "======================================"
echo "NEXVION Application Logs"
echo "======================================"

if [ ! -f "$LOG_FILE" ]; then
    echo "[INFO] No application log file exists yet."
    echo "[INFO] Start the application with logging enabled first."
    exit 0
fi

tail -n 50 "$LOG_FILE"
