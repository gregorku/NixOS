#!/usr/bin/env bash
#
# nixos-update
#
# Configuration library
#
# Loads project configuration files.
#
# SPDX-License-Identifier: MIT

set -Eeuo pipefail

#
# Prevent direct execution.
#
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	printf '%s\n' \
		"Error: lib/config.sh is a library and cannot be executed directly." >&2
	exit 1
fi

readonly CONFIG_DIR="${PROJECT_ROOT}/config"

readonly DEFAULT_CONFIG="${CONFIG_DIR}/default.conf"
readonly LOCAL_CONFIG="${CONFIG_DIR}/local.conf"

CFG_LOADED=false

##
# Return default configuration file.
#
config::default_file() {
	printf '%s\n' "${DEFAULT_CONFIG}"
}

##
# Return local configuration file.
#
config::local_file() {
	printf '%s\n' "${LOCAL_CONFIG}"
}

##
# Returns true if configuration has already been loaded.
#
config::loaded() {
	[[ "${CFG_LOADED}" == "true" ]]
}

##
# Load configuration.
#
config::load() {

	if config::loaded; then
		return 0
	fi

	if [[ ! -r "${DEFAULT_CONFIG}" ]]; then
		printf '%s\n' \
			"Error: Missing configuration file: ${DEFAULT_CONFIG}" >&2
		return 1
	fi

	# shellcheck source=/dev/null
	source "${DEFAULT_CONFIG}"

	if [[ -r "${LOCAL_CONFIG}" ]]; then
		# shellcheck source=/dev/null
		source "${LOCAL_CONFIG}"
	fi

	CFG_LOADED=true

	return 0
}
