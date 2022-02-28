#!/usr/bin/env bash

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1 
fi

# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPT_PATH=`dirname $SCRIPT`

### Include variables ###
source <(grep -v '^#' ${SCRIPT_PATH}/vars.sh | grep -v '^\[' | sed -E '/^[[:space:]]*$/d' | sed -E 's/\r/ /g')

CURRENT_PATH=$PWD

# Check if artisan exists on the current path
if [[ ! -f "$CURRENT_PATH/artisan" ]]; then
    # Fix file permission for Laravel application
    echo -n "Enter the path to ARTISAN of Laravel (/usr/share/nginx/html/APP): "
    read PATH_APP

    # Path informed has artisan file
    if [[ ! -f "$PATH_APP/artisan" ]]; then
        echo "File 'artisan' no found on this directory '${PATH_APP}'"
        exit 1
    fi
    
    cd $PATH_APP    
fi

php artisan optimize:clear
systemctl stop php${PHP_VERSION}-fpm && systemctl stop nginx 
echo "Services 'php${PHP_VERSION}-fpm' and 'nginx' STOPED";

chown -R $USER:www-data storage/ bootstrap/cache/
chmod -R 775 storage/ bootstrap/cache/
echo "Permissions changed for 'storage/' 'bootstrap/cache/'"

systemctl start php${PHP_VERSION}-fpm && systemctl start nginx
echo "Services 'php${PHP_VERSION}-fpm' and 'nginx' STARTED";
