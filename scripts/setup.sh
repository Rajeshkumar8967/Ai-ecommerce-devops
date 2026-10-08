#!/bin/bash

set -e

echo "======================================"
echo "NEXVION E-Commerce - Environment Setup"
echo "======================================"

echo "Checking required commands..."

commands=("git" "curl")

for command in "${commands[@]}"; do
    if command -v "$command" >/dev/null 2>&1; then
        echo "[OK] $command is installed"
    else
        echo "[ERROR] $command is not installed"
        exit 1
    fi
done

echo ""
echo "Project directory:"
pwd

echo ""
echo "Checking application files..."

required_files=(
    "index.html"
    "products.html"
    "payment.html"
    "script.js"
    "payment.js"
    "style.css"
    "products.css"
    "payment.css"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "[OK] $file"
    else
        echo "[ERROR] $file is missing"
        exit 1
    fi
done

echo ""
echo "Environment setup completed successfully."
