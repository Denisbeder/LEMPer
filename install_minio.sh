#!/usr/bin/env bash

# +------------------------------------------------------------------------------------------------+
# | Simple LEMP stack installer for Debian/Ubuntu forked from https://github.com/joglomedia/LEMPer |
# +------------------------------------------------------------------------------------------------+

# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPT_PATH=`dirname $SCRIPT`

### Include variables ###
source <(grep -v '^#' ${SCRIPT_PATH}/vars.sh | grep -v '^\[' | sed -E '/^[[:space:]]*$/d' | sed -E 's/\r/ /g')

export DEBIAN_FRONTEND=noninteractive

### Init Installation ###
. ./scripts/install_dependencies.sh
##. ./scripts/enable_swap.sh
. ./scripts/create_account.sh
. ./scripts/install_fail2ban.sh
. ./scripts/install_secure.sh
. ./scripts/install_minio.sh

##. ./scripts/remove_swap.sh
