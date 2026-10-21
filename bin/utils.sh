#!/usr/bin/env bash

# Author: Santhosh Siva
# Date Created: 15-12-2025

# Description:
# Loads every shared helper in bin/common. Source it, don't run it.

COMMON_DIR="$(dirname "${BASH_SOURCE[0]}")/common"

for helper in colors print prompt git deps brew node fs; do
	source "$COMMON_DIR/$helper.sh"
done
