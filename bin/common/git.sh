#!/usr/bin/env bash

# Description:
# Git and directory helpers. Source it, don't run it.

navigate_to_dir() {
	local dir=$1
	if ! cd "$dir" 2>/dev/null; then
		return 1
	fi
	return 0
}

check_uncommitted_changes() {
	if ! git diff-index --quiet HEAD --; then
		return 1
	fi
	return 0
}

is_git_repo() {
	local dir=$1
	local original_path=$PWD

	if ! navigate_to_dir "$dir"; then
		print_message "${RED}Failed to navigate to directory: ${NC}${dir}${RED}. [Fail]${NC}" 0
		exit 1
	fi

	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		navigate_to_dir "$original_path"
		return 0
	fi

	navigate_to_dir "$original_path"
	return 1
}
