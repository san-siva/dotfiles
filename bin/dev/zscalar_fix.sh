#!/usr/bin/env bash

# Author: Santhosh Siva
# Date Created: 22-06-2026

# Description:
# Make Zscaler's TLS-interception CA trusted by Node.js and Bun-based tools
# (e.g. Claude Code's HTTP MCP servers like Datadog). It extracts the
# Zscaler CA from the macOS keychain into a user-owned PEM file and
# idempotently exports NODE_EXTRA_CA_CERTS and NODE_USE_SYSTEM_CA from a shell
# rc file. By default it also rehashes the cert into the OpenSSL cert dir for
# curl/python/openssl tooling (disable with --no-system-store). Everything is
# configurable via flags.

# --- Sourcing utils -------------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

# --- Default values -------------------------------------------------------
cert_name="Zscaler"
output="$HOME/.certs/zscaler-ca.crt"
keychain="/Library/Keychains/System.keychain"
rc_file="$HOME/.zshrc"
env_var="NODE_EXTRA_CA_CERTS"
system_store=true
cert_dir="/etc/ssl/certs"

set_flags() {
	while [ $# -gt 0 ]; do
		case "$1" in
		-h | --help)
			echo "zscalar_fix - trust the Zscaler CA for Node/Bun/OpenSSL tooling"
			echo " "
			echo "zscalar_fix [options]"
			echo " "
			echo "options:"
			echo "-h, --help                        show brief help"
			echo "-n CN, --name CN                  cert common-name to search for (default: Zscaler)"
			echo "-o FILE, --output FILE            user-owned PEM to write (default: \$HOME/.certs/zscaler-ca.crt)"
			echo "-k PATH, --keychain PATH          keychain to search (default: /Library/Keychains/System.keychain)"
			echo "-r FILE, --rc FILE                shell rc file to export from (default: \$HOME/.zshrc)"
			echo "-e NAME, --env-var NAME           env var to export (default: NODE_EXTRA_CA_CERTS)"
			echo "-s, --system-store                also rehash into the OpenSSL cert dir (default; needs sudo)"
			echo "-S, --no-system-store             skip the OpenSSL cert dir rehash"
			echo "-d DIR, --cert-dir DIR            OpenSSL cert dir for --system-store (default: /etc/ssl/certs)"
			exit 0
			;;
		-n=* | --name=*)
			cert_name="${1#*=}"
			if [ -z "$cert_name" ]; then
				echo ""
				echo "${RED}Error: No certificate name specified.${NC}"
				exit 1
			fi
			;;
		-n | --name)
			shift
			if [ $# -gt 0 ]; then
				cert_name="$1"
			else
				echo ""
				echo "${RED}Error: No certificate name specified.${NC}"
				exit 1
			fi
			;;
		-o=* | --output=*)
			output="${1#*=}"
			if [ -z "$output" ]; then
				echo ""
				echo "${RED}Error: No output path specified.${NC}"
				exit 1
			fi
			;;
		-o | --output)
			shift
			if [ $# -gt 0 ]; then
				output="$1"
			else
				echo ""
				echo "${RED}Error: No output path specified.${NC}"
				exit 1
			fi
			;;
		-k=* | --keychain=*)
			keychain="${1#*=}"
			if [ -z "$keychain" ]; then
				echo ""
				echo "${RED}Error: No keychain path specified.${NC}"
				exit 1
			fi
			;;
		-k | --keychain)
			shift
			if [ $# -gt 0 ]; then
				keychain="$1"
			else
				echo ""
				echo "${RED}Error: No keychain path specified.${NC}"
				exit 1
			fi
			;;
		-r=* | --rc=*)
			rc_file="${1#*=}"
			if [ -z "$rc_file" ]; then
				echo ""
				echo "${RED}Error: No rc file specified.${NC}"
				exit 1
			fi
			;;
		-r | --rc)
			shift
			if [ $# -gt 0 ]; then
				rc_file="$1"
			else
				echo ""
				echo "${RED}Error: No rc file specified.${NC}"
				exit 1
			fi
			;;
		-e=* | --env-var=*)
			env_var="${1#*=}"
			if [ -z "$env_var" ]; then
				echo ""
				echo "${RED}Error: No env var name specified.${NC}"
				exit 1
			fi
			;;
		-e | --env-var)
			shift
			if [ $# -gt 0 ]; then
				env_var="$1"
			else
				echo ""
				echo "${RED}Error: No env var name specified.${NC}"
				exit 1
			fi
			;;
		-d=* | --cert-dir=*)
			cert_dir="${1#*=}"
			if [ -z "$cert_dir" ]; then
				echo ""
				echo "${RED}Error: No cert dir specified.${NC}"
				exit 1
			fi
			;;
		-d | --cert-dir)
			shift
			if [ $# -gt 0 ]; then
				cert_dir="$1"
			else
				echo ""
				echo "${RED}Error: No cert dir specified.${NC}"
				exit 1
			fi
			;;
		-s | --system-store)
			system_store=true
			;;
		-S | --no-system-store)
			system_store=false
			;;
		*)
			echo "${RED}Unknown option:${NC} $1"
			exit 1
			;;
		esac
		shift
	done
}

# Extract the CA cert(s) from the keychain into a user-owned PEM file.
extract_cert() {
	local name=$1
	local kc=$2
	local out=$3
	local step_number=$4

	print_message "${BLUE}Extracting ${NC}${name}${BLUE} CA from ${NC}${kc}${BLUE}...${NC}" $step_number

	if [ ! -r "$kc" ]; then
		print_message "" -1
		print_message "${RED}Keychain not readable: ${NC}${kc}${RED}. [Fail]${NC}" -1
		exit 1
	fi

	local out_dir
	out_dir="$(dirname "$out")"
	if ! mkdir -p "$out_dir" 2>&1 | indent; then
		print_message "" -1
		print_message "${RED}Failed to create ${NC}${out_dir}${RED}. [Fail]${NC}" -1
		exit 1
	fi

	local tmp
	tmp="$(mktemp)"
	if ! security find-certificate -a -p -c "$name" "$kc" >"$tmp" 2>/dev/null; then
		rm -f "$tmp"
		print_message "" -1
		print_message "${RED}Failed to query the keychain. [Fail]${NC}" -1
		exit 1
	fi

	local count
	count=$(grep -c "BEGIN CERTIFICATE" "$tmp")
	if [ "$count" -lt 1 ]; then
		rm -f "$tmp"
		print_message "" -1
		print_message "${RED}No certificate matching ${NC}${name}${RED} found in keychain. [Fail]${NC}" -1
		exit 1
	fi

	mv "$tmp" "$out"
	chmod 644 "$out"
	print_message "${GREEN}Wrote ${count} cert(s) to ${NC}${out}${GREEN}. [DONE]${NC}" 0
	return 0
}

# Idempotently export env vars from the rc file.
update_rc() {
	local rc=$1
	local var=$2
	local value=$3
	local step_number=$4

	local marker="# zscalar_fix: ${var} integration"
	local line="export ${var}=\"${value}\""

	print_message "${BLUE}Exporting ${NC}${var}${BLUE} from ${NC}${rc}${BLUE}...${NC}" $step_number

	touch "$rc"

	if grep -qxF "$line" "$rc" 2>/dev/null; then
		print_message "${GREEN}Already configured, nothing to do. [DONE]${NC}" 0
		return 0
	fi

	if grep -q "^export ${var}=" "$rc" 2>/dev/null; then
		if ! sed -i '' "s|^export ${var}=.*|${line}|" "$rc"; then
			print_message "" -1
			print_message "${RED}Failed to update ${NC}${rc}${RED}. [Fail]${NC}" -1
			exit 1
		fi
		print_message "${GREEN}Updated existing export. [DONE]${NC}" 0
		return 0
	fi

	printf '\n%s\n%s\n' "$marker" "$line" >>"$rc"
	print_message "${GREEN}Appended export. [DONE]${NC}" 0
	return 0
}

# Rehash the cert into the OpenSSL cert dir.
# Creates directory if missing via sudo.
install_system_store() {
	local cert=$1
	local dir=$2
	local step_number=$3

	print_message "${BLUE}Installing into OpenSSL store ${NC}${dir}${BLUE} (sudo)...${NC}" $step_number

	# Ensure the directory exists safely
	if [ ! -d "$dir" ]; then
		if ! sudo mkdir -p "$dir" 2>&1 | indent; then
			print_message "" -1
			print_message "${RED}Failed to create directory: ${NC}${dir}${RED}. [Fail]${NC}" -1
			exit 1
		fi
	fi

	# Always navigate into the right destination directory context
	if ! cd "$dir" 2>/dev/null; then
		print_message "" -1
		print_message "${RED}Failed to cd into ${NC}${dir}${RED}. [Fail]${NC}" -1
		exit 1
	fi

	local base
	base="$(basename "$cert")"

	if ! sudo cp "$cert" "./${base}" 2>&1 | indent; then
		print_message "" -1
		print_message "${RED}Failed to copy cert into ${NC}${dir}${RED}. [Fail]${NC}" -1
		exit 1
	fi

	local hash
	hash="$(openssl x509 -hash -noout -in "$cert" 2>/dev/null)"
	if [ -z "$hash" ]; then
		print_message "" -1
		print_message "${RED}Failed to compute cert hash. [Fail]${NC}" -1
		exit 1
	fi

	if ! sudo ln -sf "$base" "./${hash}.0" 2>&1 | indent; then
		print_message "" -1
		print_message "${RED}Failed to create hash symlink. [Fail]${NC}" -1
		exit 1
	fi

	print_message "${GREEN}Rehashed as ${NC}${hash}.0${GREEN}. [DONE]${NC}" 0
	return 0
}

main() {
	set_flags "$@"
	validate_dependencies openssl
	print_banner

	# 1. Extract CA certificate
	extract_cert "$cert_name" "$keychain" "$output" 1

	# 2. Update Node Environment
	update_rc "$rc_file" "$env_var" "$output" 2

	# 3. Explicitly support Bun runtime engine environment configuration (Claude Code)
	update_rc "$rc_file" "NODE_USE_SYSTEM_CA" "1" 3

	# 4. Optional System Store updates
	if [ "$system_store" = "true" ]; then
		install_system_store "$output" "$cert_dir" 4
	fi

	print_message "" -1
	print_message "${GREEN}Done. Open a new shell (or run: ${NC}source ${rc_file}${GREEN}) to flush changes. [DONE]${NC}" -1
}

# Only run main if script is executed directly (not sourced)
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
	main "$@"
	exit 0
fi
