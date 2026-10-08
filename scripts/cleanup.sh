#!/bin/bash

echo "======================================"
echo "NEXVION Project Cleanup"
echo "======================================"

echo "[INFO] Removing temporary files..."

find . -type f -name "*.tmp" -delete
find . -type f -name "*.log" -delete

echo "[OK] Cleanup completed."
