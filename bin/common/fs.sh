#!/usr/bin/env bash

# Description:
# Filesystem helpers. Source it, don't run it.

link() {
	# link <source> <destination>
	local src=$1 dst=$2
	mkdir -p "$(dirname "$dst")"
	if [ -d "$dst" ] && [ ! -L "$dst" ]; then
		# ln -f can't replace a real directory; move it aside instead
		local backup="${dst}.bak-$(date +%Y%m%d%H%M%S)"
		echo "Moving existing directory $dst to $backup"
		mv "$dst" "$backup"
	fi
	ln -sfn "$src" "$dst"
}
