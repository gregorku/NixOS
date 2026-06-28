#!/usr/bin/env bash
#
# nixos-update
#
# Core library
#
# This file provides the basic project information and helper
# functions shared by all modules.
#
# SPDX-License-Identifier: MIT

set -Eeuo pipefail

#
# Prevent direct execution.
#
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    printf '%s\n' "Error: lib/core.sh is a library and cannot be executed directly." >&2
    exit 1
fi

readonly CORE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd -- "${CORE_DIR}/.." && pwd)"
readonly PROJECT_NAME="nixos-update"
readonly VERSION_FILE="${PROJECT_ROOT}/VERSION"

##
# Return absolute project root.
#
# stdout:
#   /path/to/tools/nixos-update
#
core::project_root() {
    printf '%s\n' "${PROJECT_ROOT}"
}

##
# Return project name.
#
core::project_name() {
    printf '%s\n' "${PROJECT_NAME}"
}

##
# Return project version.
#
# Reads VERSION file.
#
core::version() {

    if [[ -r "${VERSION_FILE}" ]]; then
        head -n1 "${VERSION_FILE}"
        return 0
    fi

    printf '%s\n' "unknown"
}

##
# Return path to VERSION file.
#
core::version_file() {
    printf '%s\n' "${VERSION_FILE}"
}