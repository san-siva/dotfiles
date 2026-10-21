#!/usr/bin/env bash

# Description:
# Terminal colors. Source it, don't run it.

# Colors
BLUE=$(tput setaf 4)
PROMPT=$(tput setaf 3)
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
NC=$(tput sgr0)

overwrite() { echo -e "\r\033[1A\033[0K$@"; }
