#!/usr/bin/env bash
#
# nixos-update
#
# Logging library
#
# SPDX-License-Identifier: MIT

set -Eeuo pipefail

#
# Prevent direct execution.
#
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	printf '%s\n' \
		"Error: lib/logging.sh is a library and cannot be executed directly." >&2
	exit 1
fi

LOG_FILE=""

##
# Configure log file.
#
log::set_file() {
	LOG_FILE="$1"
}

##
# Return current timestamp.
#
log::timestamp() {
	date '+%Y-%m-%d %H:%M:%S'
}

##
# Internal logger.
#
log::_write() {

	local level="$1"
	shift

	local message="$*"
	local line

	line="$(log::timestamp) [${level}] ${message}"

	printf '%s\n' "${line}"

	if [[ -n "${LOG_FILE}" ]]; then
		printf '%s\n' "${line}" >>"${LOG_FILE}"
	fi
}

##
# INFO
#
log::info() {
	log::_write INFO "$@"
}

##
# WARNING
#
log::warn() {
	log::_write WARN "$@"
}

##
# ERROR
#
log::error() {
	log::_write ERROR "$@"
}

##
# SUCCESS
#
log::success() {
	log::_write OK "$@"
}
