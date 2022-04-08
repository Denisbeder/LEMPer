#!/bin/bash

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1 
fi

# Confirm directory NGINX exists
if [[ ! -d "/etc/nginx" ]]; then
    echo "Not found '/etc/nginx' directory. Please ensure has NGINX installed."
	exit 1
fi

SITES_AVAILABLE="/etc/nginx/sites-available"
SITES_ENABLED="/etc/nginx/sites-enabled"
ROOT_PATH_BASE="/usr/share/nginx/html"
VHOST="/etc/nginx/vhost/site_laravel.conf"

echo -n "Enter the name a domain: "
read DOMAIN

DOMAIN_PATH="$ROOT_PATH_BASE/$DOMAIN"
PATH_ARTISAN="$DOMAIN_PATH"

# verify if project directory exists before proceed
if [[ ! -d $DOMAIN_PATH ]]; then
    echo "This directory $DOMAIN_PATH not exists. First create this directory in $ROOT_PATH_BASE and install the project Laravel before run this script."
fi

echo -n "Select PHP Version to $DOMAIN_PATH (7.2 - 7.4 - 8.0 - 8.1): "
read PHPv

PHP_VERSION=${PHPv:-7.4}

echo -n "Create CRONTAB for Laravel 'schedule' to this domain? (yes/no): "
read CREATE_CRONTAB

echo -n "Create WORKER for Laravel 'queue' to this domain? (yes/no): "
read CREATE_WORKER

if [[ "$CREATE_CRONTAB" == "yes" || "$CREATE_WORKER" == "yes" ]]; then
    if [[ ! -f "$PWD/artisan" ]]; then echo "tem artijsan" fi
        echo -n "Where is the path to Laravel ARTISAN? (empty=default): "
        read PATH_ARTISAN
        # Condition ternary. If variable $PATH_ARTISAN is empty then set to current directory
        [ $PATH_ARTISAN ] && PATH_ARTISAN=$PATH_ARTISAN || PATH_ARTISAN=$DOMAIN_PATH
    fi
fi

if [[ "$CREATE_WORKER" == "yes" ]]; then
    echo "Creating this WORK on /etc/supervisor/conf.d/laravel-worker-$DOMAIN.conf"
    echo "[program:laravel-worker-${DOMAIN}]
process_name=%(program_name)s_%(process_num)02d
command=php ${PATH_ARTISAN}/artisan queue:work --sleep=3 --tries=3
autostart=true
autorestart=true
user=$(whoami)
numprocs=1
redirect_stderr=true
stdout_logfile=${DOMAIN_PATH}/worker.log
stopwaitsecs=3600" > /etc/supervisor/conf.d/laravel-worker-$DOMAIN.conf
fi

echo -n "User JosephSilber/page-cache Laravel Package? (yes/no): "
read USE_PAGE_CACHE

if [[ "$USE_PAGE_CACHE" == "yes" ]]; then
	VHOST="/etc/nginx/vhost/site_laravel_page_cache.conf"
fi

# Confirm directory exists
if [[ ! -d $SITES_AVAILABLE ]]; then
    echo "Creating directory $SITES_AVAILABLE"
	mkdir -p $SITES_AVAILABLE
fi

# Confirm directory exists
if [[ ! -d $SITES_ENABLED ]]; then
    echo "Creating directory $SITES_ENABLED"
	mkdir -p $SITES_ENABLED
fi

# Confirm if is to create CRONTAB
if [[ "$CREATE_CRONTAB" == "yes" ]]; then
    echo "Creating this CRONTAB: * * * * * www-data cd ${PATH_ARTISAN} && php artisan schedule:run >> /dev/null 2>&1"
    echo "* * * * * www-data cd ${PATH_ARTISAN} && php artisan schedule:run >> /dev/null 2>&1" >> /etc/crontab
fi

# Change permissions
chown -R $(whoami):www-data "$DOMAIN_PATH"

# Create server to domain the on NGINX
echo "server {
    listen 80;
    listen [::]:80;

    server_name $DOMAIN *.$DOMAIN;

    #include /etc/nginx/includes/ssl.conf;
    
    # SSL by Cloudflare
    #ssl_certificate /etc/cloudflare/publkey.pem;
    #ssl_certificate_key /etc/cloudflare/privkey.pem;
    #ssl_client_certificate /etc/cloudflare/origin-pull-ca.pem;

    access_log /var/log/nginx/$DOMAIN.access.log;
    error_log /var/log/nginx/$DOMAIN.error.log;

    root $DOMAIN_PATH/public;
    index index.php index.html index.htm;

    include /etc/nginx/includes/rules_security.conf;
    include /etc/nginx/includes/rules_staticfiles.conf;
    include /etc/nginx/includes/rules_restriction.conf;

    include $VHOST;

    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_index index.php;
        include /etc/nginx/fastcgi_params;
        include /etc/nginx/includes/fastcgi.conf;
        fastcgi_pass unix:/run/php/php${PHP_VERSION}-fpm.sock;
    }

    #include /etc/nginx/includes/error_pages.conf;

    include /etc/nginx/includes/fcgiwrap.conf;
}" > $SITES_AVAILABLE/$DOMAIN

# Create link simbolic to domain when not exists
if [[ ! -f "$SITES_ENABLED/$DOMAIN" ]]; then
    ln -s "$SITES_AVAILABLE/$DOMAIN" $SITES_ENABLED
fi

# After set configs restart NGINX
systemctl restart nginx.service

echo -e "Domain name $DOMAIN created on: \n$DOMAIN_PATH \n$SITES_AVAILABLE/$DOMAIN"