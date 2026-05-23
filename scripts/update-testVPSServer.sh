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
    echo "ERROR: Repository contains local changes"

    git status --short

    exit 1
fi

echo ""
echo "=== Git pull ==="

git pull --ff-only

echo ""
echo "=== Starting deploy ==="

"$FLAKE_DIR/scripts/deploy-testVPSServer.sh"

echo ""
read -rp "Upgrade packages (flake update)? [y/N]: " REPLY

if [[ "$REPLY" =~ ^[Yy]$ ]]; then

    exec "$FLAKE_DIR/scripts/upgrade-testVPSServer.sh"

fi