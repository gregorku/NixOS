#!/usr/bin/env bash

set -Eeuo pipefail

# =========================================
# NixOS rebuild script
# Host: testVPSServer
# =========================================

HOST="testVPSServer"
FLAKE_DIR="$HOME/NixOS"

TMP_LINK="/tmp/nixos-new-system"

# =========================================
# START
# =========================================

echo ""
echo "========================================="
echo "NixOS rebuild: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Host: $HOST"
echo "========================================="
echo ""

cd "$FLAKE_DIR"

# =========================================
# GIT PULL
# =========================================

echo "=== Git pull ==="

if ! git diff --quiet; then
  echo ""
  echo "ERROR: Git repository contains local changes"
  echo ""

  git status --short

  exit 1
fi

git pull --ff-only

# =========================================
# CURRENT SYSTEM
# =========================================

echo ""
echo "=== Current system ==="

OLD_SYSTEM=$(readlink /run/current-system)
OLD_KERNEL=$(uname -r)

echo "$OLD_SYSTEM"

# =========================================
# BUILD
# =========================================

echo ""
echo "=== Building new system ==="

rm -f "$TMP_LINK"

nix build ".#nixosConfigurations.${HOST}.config.system.build.toplevel" \
  --out-link "$TMP_LINK"

NEW_SYSTEM=$(readlink -f "$TMP_LINK")

# =========================================
# PACKAGE DIFF
# =========================================

echo ""
echo "=== Package changes (nvd) ==="

if [[ "$OLD_SYSTEM" == "$NEW_SYSTEM" ]]; then
  echo "No package changes"
else
  nvd diff "$OLD_SYSTEM" "$NEW_SYSTEM" || true
fi

echo ""
echo "=== Closure diff ==="

nix store diff-closures "$OLD_SYSTEM" "$NEW_SYSTEM" || true

# =========================================
# ACTIVATE
# =========================================

echo ""
echo "=== Activating configuration ==="

REBOOT_REQUIRED=0

if sudo nixos-rebuild switch --flake ".#${HOST}"; then
  echo ""
  echo "SUCCESS: switch completed"
else
  echo ""
  echo "WARNING: switch failed"
  echo "Falling back to boot mode..."

  sudo nixos-rebuild boot --flake ".#${HOST}"

  REBOOT_REQUIRED=1
fi

# =========================================
# FAILED SERVICES
# =========================================

echo ""
echo "=== Failed services ==="

FAILED_UNITS=$(systemctl list-units --failed --no-legend || true)

if [[ -z "$FAILED_UNITS" ]]; then
  echo "No failed services"
else
  echo "$FAILED_UNITS"
fi

# =========================================
# KERNEL CHECK
# =========================================

echo ""
echo "=== Kernel check ==="

NEW_KERNEL=$(nix eval --raw ".#nixosConfigurations.${HOST}.config.boot.kernelPackages.kernel.version")

if [[ "$OLD_KERNEL" != "$NEW_KERNEL" ]]; then
  echo "Kernel changed:"
  echo "  OLD: $OLD_KERNEL"
  echo "  NEW: $NEW_KERNEL"

  REBOOT_REQUIRED=1
else
  echo "Kernel unchanged"
fi

# =========================================
# CLEANUP
# =========================================

rm -f "$TMP_LINK"

# refresh nix metadata
sudo nix store gc --debug >/dev/null 2>&1 || true

# =========================================
# REBOOT INFO
# =========================================

if [[ "$REBOOT_REQUIRED" -eq 1 ]]; then
  echo ""
  echo "========================================="
  echo "Reboot recommended"
  echo "Run:"
  echo "sudo reboot"
  echo "========================================="
fi

# =========================================
# DONE
# =========================================

echo ""
echo "========================================="
echo "DONE"
echo "========================================="
echo ""
