#!/usr/bin/env bash

set -Eeuo pipefail

HOST="testVPSServer"
FLAKE_DIR="$HOME/NixOS"

TMP_LINK="/tmp/.nixos-new-system"

echo ""
echo "========================================="
echo "NixOS deploy: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Host: $HOST"
echo "========================================="
echo ""

cd "$FLAKE_DIR"

if ! git diff --quiet; then
    echo ""
    echo "ERROR: Git repository contains local changes"
    echo ""

    git status --short
    exit 1
fi

echo ""
echo "=== Current system ==="

OLD_SYSTEM=$(readlink /run/current-system)
OLD_KERNEL=$(uname -r)

echo "$OLD_SYSTEM"

echo ""
echo "=== Building new system ==="

rm -f "$TMP_LINK"

nix build \
".#nixosConfigurations.${HOST}.config.system.build.toplevel" \
--out-link "$TMP_LINK"

NEW_SYSTEM=$(readlink -f "$TMP_LINK")

echo ""
echo "=== Activating configuration ==="

REBOOT_REQUIRED=0

if sudo nixos-rebuild switch --flake ".#${HOST}"; then

    echo ""
    echo "SUCCESS: switch completed"

else

    echo ""
    echo "WARNING: switch failed"
    echo "Fallback → boot"

    sudo nixos-rebuild boot --flake ".#${HOST}"

    REBOOT_REQUIRED=1
fi

echo ""
echo "=== Failed services ==="

FAILED_UNITS=$(
systemctl list-units \
--failed \
--no-legend || true
)

if [[ -z "$FAILED_UNITS" ]]; then
    echo "No failed services"
else
    echo "$FAILED_UNITS"
fi

echo ""
echo "=== Kernel check ==="

NEW_KERNEL=$(
nix eval --raw \
".#nixosConfigurations.${HOST}.config.boot.kernelPackages.kernel.version"
)

if [[ "$OLD_KERNEL" != "$NEW_KERNEL" ]]; then

    echo "Kernel changed:"
    echo " OLD: $OLD_KERNEL"
    echo " NEW: $NEW_KERNEL"

    REBOOT_REQUIRED=1

else

    echo "Kernel unchanged"

fi

rm -f "$TMP_LINK"

if [[ "$REBOOT_REQUIRED" -eq 1 ]]; then

echo ""
echo "========================================="
echo "Reboot recommended"
echo "sudo reboot"
echo "========================================="

fi

echo ""
echo "========================================="
echo "DONE"
echo "========================================="