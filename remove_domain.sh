#!/bin/bash

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1 
fi

echo -n "Enter the name a domain to remove: "
read DOMAIN

SITES_AVAILABLE="/etc/nginx/sites-available"
SITES_ENABLED="/etc/nginx/sites-enabled"

# Delete line schedule of CRONTAB
sed -i "/$DOMAIN/d" /etc/crontab

# remove worker
rm -f /etc/supervisor/conf.d/laravel-worker-$DOMAIN.conf >> /dev/null 2>&1

# remove server to domain the on NGINX
rm -f $SITES_AVAILABLE/$DOMAIN $SITES_ENABLED/$DOMAIN >> /dev/null 2>&1

# After set configs restart NGINX
systemctl restart nginx.service

echo -e "Domain name $DOMAIN was removed