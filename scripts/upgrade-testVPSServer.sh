#!/usr/bin/env bash

set -Eeuo pipefail

HOST="testVPSServer"
FLAKE_DIR="$HOME/NixOS"

OLD="/tmp/.old-system"
NEW="/tmp/.new-system"

echo ""
echo "========================================="
echo "Package upgrade"
echo "========================================="
echo ""

cd "$FLAKE_DIR"

echo "=== Updating flake ==="

nix flake update

echo ""
echo "=== Building old ==="

nix build \
".#nixosConfigurations.${HOST}.config.system.build.toplevel" \
--out-link "$OLD"

echo ""
echo "=== Building new ==="

nix build \
".#nixosConfigurations.${HOST}.config.system.build.toplevel" \
--out-link "$NEW"

echo ""
echo "=== Updated packages ==="

if command -v nvd >/dev/null; then

nvd diff \
"$(readlink -f "$OLD")" \
"$(readlink -f "$NEW")"

fi

echo ""
echo "=== Commit ==="

git add flake.lock

git commit \
-m "update flake inputs $(date +%F)" \
|| true

echo ""
echo "=== Push ==="

git push

rm -f "$OLD"
rm -f "$NEW"

echo ""
echo "=== Deploy updated system ==="

exec "$FLAKE_DIR/scripts/deploy-testVPSServer.sh"