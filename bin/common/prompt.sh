#!/usr/bin/env bash

# Description:
# Asking the user questions. Source it, don't run it.

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
