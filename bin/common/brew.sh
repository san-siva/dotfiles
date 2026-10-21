#!/usr/bin/env bash

# Description:
# Homebrew helpers. Source it, don't run it.

load_brew() {
	# Each setup script runs in its own shell, so brew has to be put on PATH again
	if [ -x "/opt/homebrew/bin/brew" ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
}

brew_install() {
	# brew_install <command> [formula] [brew flags...]
	# Installs the formula unless <command> is already on PATH
	local command_name="$1"
	local formula="${2:-$1}"
	shift $(($# > 1 ? 2 : 1))

	if [ -n "$(command -v "$command_name")" ]; then
		echo "$formula already installed"
	else
		echo "Installing $formula"
		brew install "$@" "$formula"
	fi
}
