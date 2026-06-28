#!/usr/bin/env bash
#
# nixos-update
#
# Core library
#
# Provides basic project information shared by all modules.
#
# SPDX-License-Identifier: MIT

set -Eeuo pipefail

#
# Prevent direct execution.
#
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    printf '%s\n' \
        "Error: lib/core.sh is a library and cannot be executed directly." >&2
    exit 1
fi

readonly CORE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd -- "${CORE_DIR}/.." && pwd)"
readonly LIB_DIR="${PROJECT_ROOT}/lib"
readonly PROJECT_NAME="nixos-update"
readonly VERSION_FILE="${PROJECT_ROOT}/VERSION"

##
# Return project root directory.
#
core::project_root() {
    printf '%s\n' "${PROJECT_ROOT}"
}

##
# Alias for project_root().
#
core::project_dir() {
    core::project_root
}

##
# Return library directory.
#
core::lib_dir() {
    printf '%s\n' "${LIB_DIR}"
}

##
# Return project name.
#
core::project_name() {
    printf '%s\n' "${PROJECT_NAME}"
}

##
# Return VERSION file path.
#
core::version_file() {
    printf '%s\n' "${VERSION_FILE}"
}

##
# Return project version.
#
core::version() {

    local version="unknown"

    if [[ -r "${VERSION_FILE}" ]]; then
        if IFS= read -r version < "${VERSION_FILE}"; then
            printf '%s\n' "${version}"
            return 0
        fi
    fi

    printf '%s\n' "unknown"
}