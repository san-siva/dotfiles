#!/usr/bin/env bash

# Description:
# Installing missing commands (needs print.sh and colors.sh). Source it, don't run it.

install_dependency() {
	local cmd=$1
	local package=$2

	if ! command -v "$cmd" >/dev/null; then
		if brew install "$package" >>"$log_file" 2>>"$error_log_file"; then
			return
		else
			print_message "${RED}Failed to install $package.${NC}"
			exit 1
		fi
	fi
}

validate_dependencies() {
	for cmd in $@; do
		install_dependency "$cmd" "$cmd"
	done
}
