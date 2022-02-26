#!/usr/bin/env bash

# +------------------------------------------------------------------------------------------------+
# | Simple LEMP stack installer for Debian/Ubuntu forked from https://github.com/joglomedia/LEMPer |
# +------------------------------------------------------------------------------------------------+

### Include variables ###
source <(grep -v '^#' vars.sh | grep -v '^\[' | sed -E '/^[[:space:]]*$/d' | sed -E 's/\r/ /g')

export DEBIAN_FRONTEND=noninteractive

### Init Installation ###
. ./scripts/install_dependencies.sh
##. ./scripts/enable_swap.sh
. ./scripts/create_account.sh
. ./scripts/install_fail2ban.sh
. ./scripts/install_secure.sh
. ./scripts/install_mariadb.sh

##. ./scripts/remove_swap.sh
