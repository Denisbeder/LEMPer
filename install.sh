#!/usr/bin/env bash

# +------------------------------------------------------------------------------------------------+
# | Simple LEMP stack installer for Debian/Ubuntu forked from https://github.com/joglomedia/LEMPer |
# +------------------------------------------------------------------------------------------------+

export DEBIAN_FRONTEND=noninteractive

### Include variables ###
source <(grep -v '^#' vars.sh | grep -v '^\[' | sed -E '/^[[:space:]]*$/d' | sed -E 's/\r/ /g')

### Init Installation ###
. ./scripts/create_account.sh
. ./scripts/install_dependencies.sh
##. ./scripts/enable_swap.sh
##. ./scripts/install_certbot.sh
. ./scripts/install_nginx.sh
. ./scripts/install_nodejs.sh
. ./scripts/install_php.sh
. ./scripts/install_memcached.sh
. ./scripts/install_redis.sh
. ./scripts/install_supervisor.sh
##. ./scripts/install_mariadb.sh
. ./scripts/install_fail2ban.sh
. ./scripts/install_secure.sh

##. ./scripts/remove_swap.sh