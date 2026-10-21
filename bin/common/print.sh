#!/usr/bin/env bash

# Description:
# Printing messages, indentation and the banner. Source it, don't run it.

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

	# Negative (e.g. -1): flush left, no indent — blank spacers and error lines.
	if [ "$number" -lt 0 ]; then
		echo -e "$message"
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

print_banner() {
	print_message ""
	figlet -f slant "Sankit" | lolcat
	print_message ""
}
