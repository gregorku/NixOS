#!/usr/bin/env bash

set -Eeuo pipefail

HOST="testVPSServer"
FLAKE_DIR="$HOME/NixOS"

TMP_OLD="/tmp/.old-system"
TMP_NEW="/tmp/.new-system"

cd "$FLAKE_DIR"

echo ""
echo "========================================="
echo "NixOS package upgrade"
echo "========================================="
echo ""

if ! git diff --quiet; then
    echo ""
    echo "ERROR: Repository contains local changes"
    git status --short
    exit 1
fi

echo ""
echo "=== Saving current system ==="

nix build \
".#nixosConfigurations.${HOST}.config.system.build.toplevel" \
--out-link "$TMP_OLD"

echo ""
echo "=== Updating flake ==="

nix flake update

echo ""
echo "=== Building updated system ==="

nix build \
".#nixosConfigurations.${HOST}.config.system.build.toplevel" \
--out-link "$TMP_NEW"

echo ""
echo "=== Updated packages ==="

if command -v nvd >/dev/null; then
    nvd diff \
    "$(readlink -f "$TMP_OLD")" \
    "$(readlink -f "$TMP_NEW")"
fi

echo ""
echo "=== Commit ==="

git add flake.lock
git commit -m "update flake inputs $(date +%F)" || true

echo ""
echo "=== Push ==="

git push

rm -f "$TMP_OLD"
rm -f "$TMP_NEW"

echo ""
echo "=== Starting deploy ==="

exec "$FLAKE_DIR/scripts/update-testVPSServer.sh"