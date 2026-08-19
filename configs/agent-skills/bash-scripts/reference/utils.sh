#!/usr/bin/env bash

# Author: Santhosh Siva
# Date Created: 15-12-2025

# Colors
BLUE=$(tput setaf 4)
PROMPT=$(tput setaf 3)
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
NC=$(tput sgr0)

overwrite() { echo -e "\r\033[1A\033[0K$@"; }

default_spaces="    "

print_message() {
	local number=$2
	local message=$1

	if [ -z "$message" ]; then
		message=""
	fi

	if [ -z "$number" ]; then
		number=0
	fi

	if [ "$number" -eq 0 ]; then
		echo -e "   $message"
		return 0
	fi

	# print_message ""

	if [ "$number" -lt 10 ]; then
		printf "%d. %s\n" "$number" "$message"
		return 0
	fi

	printf "%02d. %s\n" "$number" "$message"
}

indent() {
	local prefix="   │ "
	sed "s/^/${prefix}/"
}

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

print_banner() {
	print_message ""
	figlet -f slant "Sankit" | lolcat
	print_message ""
}

prompt_user() {
	local default_to_yes=$1
	local message=$2
	local step_number=$3

	if [ -n "$step_number" ] && [ "$step_number" -ne 0 ]; then
		local prefix="$(printf "%${default_spaces}s")${step_number}. "
	elif [ "$step_number" -eq 0 ]; then
		local prefix="$(printf "%${default_spaces}s")   "
	else
		local prefix="$(printf "%${default_spaces}s")- "
	fi

	local prompt="${prefix}${PROMPT}${message}${NC} "

	if [ "$default_to_yes" = "true" ]; then
		read -p "${prompt}(Y/n): " response
		response="${response:-y}"
	else
		read -p "${prompt}(y/N): " response
		response="${response:-n}"
	fi

	case "$response" in
	[Yy]) echo "y" ;;
	[Nn]) echo "n" ;;
	*) print_message "Invalid input." 0 && exit 1 ;;
	esac
}

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
