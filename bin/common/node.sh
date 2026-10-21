#!/usr/bin/env bash

# Description:
# nvm and global npm helpers. Source it, don't run it.

load_nvm() {
	# nvm is a shell function, so every setup script has to load it again
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

npm_install() {
	# npm_install <package>...
	# Installs the packages globally
	if [ -z "$(command -v npm)" ]; then
		load_nvm
	fi

	if [ -z "$(command -v npm)" ]; then
		echo "npm not found, skipping: $*"
		return 1
	fi

	npm install -g "$@"
}
