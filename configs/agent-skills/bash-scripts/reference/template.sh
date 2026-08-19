#!/usr/bin/env bash

# Author: Santhosh Siva
# Date Created: DD-MM-YYYY

# Description:
# <One or two lines describing what this script does.>

# --- Sourcing utils -------------------------------------------------------
# Option A — project-encapsulated (copy `utils` into this repo's bin/):
# Resolve script directory (follows symlinks)
SOURCE="${BASH_SOURCE[0]}"
while [ -L "$SOURCE" ]; do
	DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
	SOURCE="$(readlink "$SOURCE")"
	[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
source "$SCRIPT_DIR/utils"

# Option B — central personal scripts under ~/.config/bin/ :
# source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

# --- Default values -------------------------------------------------------
target_branch=
force=false

set_flags() {
	while [ $# -gt 0 ]; do
		case "$1" in
		-h | --help)
			echo "tool-name - one-line purpose"
			echo " "
			echo "tool-name [options]"
			echo " "
			echo "options:"
			echo "-h, --help                                       show brief help"
			echo "-t BRANCH, -t=BRANCH, --target-branch BRANCH     specify the target branch"
			echo "-f, --force                                      force the operation"
			exit 0
			;;
		-t=* | --target-branch=*)
			target_branch="${1#*=}"
			if [ -z "$target_branch" ]; then
				echo ""
				echo "${RED}Error: No target branch specified.${NC}"
				exit 1
			fi
			;;
		-t | --target-branch)
			shift
			if [ $# -gt 0 ]; then
				target_branch="$1"
			else
				echo ""
				echo "${RED}Error: No target branch specified.${NC}"
				exit 1
			fi
			;;
		-f | --force)
			force=true
			;;
		*)
			echo "${RED}Unknown option:${NC} $1"
			exit 1
			;;
		esac
		shift
	done
}

# A worker function: one job, inputs as locals, output via nameref.
do_the_work() {
	local branch=$1
	local step_number=$2

	if [ -z "$step_number" ]; then
		step_number=0
	fi

	print_message "${BLUE}Working on ${NC}${branch}${BLUE}...${NC}" $step_number

	if ! git -c color.ui=always status 2>&1 | indent; then
		print_message "" -1
		print_message "${RED}Failed to do the work. [Fail]${NC}" -1
		exit 1
	fi

	print_message "${GREEN}Done. [DONE]${NC}"
	return 0
}

main() {
	set_flags "$@"
	validate_dependencies git
	print_banner

	if [ -z "$target_branch" ]; then
		local current_branch
		get_current_branch current_branch
		target_branch="$current_branch"
	fi

	do_the_work "$target_branch" 1
}

# Only run main if script is executed directly (not sourced)
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
	main "$@"
	exit 0
fi
