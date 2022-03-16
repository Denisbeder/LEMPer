#!/usr/bin/env bash

# +------------------------------------------------------------------------------------------------+
# | Simple LEMP stack installer for Debian/Ubuntu forked from https://github.com/joglomedia/LEMPer |
# +------------------------------------------------------------------------------------------------+

export DEBIAN_FRONTEND=noninteractive

# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPT_PATH=`dirname $SCRIPT`

### Include variables ###
source <(grep -v '^#' ${SCRIPT_PATH}/vars.sh | grep -v '^\[' | sed -E '/^[[:space:]]*$/d' | sed -E 's/\r/ /g')

### Init Installation ###
. ./scripts/install_dependencies.sh
. ./scripts/create_account.sh
. ./scripts/install_fail2ban.sh
. ./scripts/install_secure.sh
##. ./scripts/enable_swap.sh
##. ./scripts/install_certbot.sh
. ./scripts/install_nginx.sh
. ./scripts/install_php.sh
. ./scripts/install_memcached.sh
. ./scripts/install_redis.sh
. ./scripts/install_supervisor.sh
##. ./scripts/install_mariadb.sh
. ./scripts/install_nodejs.sh

##. ./scripts/remove_swap.sh

ech -n "Do you want create a new domain? (yes/no)"
read CREATE_NEW_DOMAIN

if [ $CREATE_NEW_DOMAIN == "yes" ]; then
. ./create_domain.sh
fi
