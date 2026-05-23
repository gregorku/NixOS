#!/usr/bin/env bash

set -Eeuo pipefail

FLAKE_DIR="$HOME/NixOS"

echo ""
echo "========================================="
echo "NixOS update"
echo "========================================="
echo ""

cd "$FLAKE_DIR"

echo "=== Checking git status ==="

if ! git diff --quiet; then
    echo ""
    echo "ERROR: Git repository contains local changes"
    echo ""

    git status --short
    exit 1
fi

echo ""
echo "=== Git pull ==="

git pull --ff-only

echo ""
echo "=== Starting rebuild ==="

exec "$FLAKE_DIR/scripts/rebuild-testVPSServer.sh"