#!/bin/bash

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1 
fi

# Confirm directory NGINX exists
if [[ ! -d "/etc/nginx" ]]; then
    echo "Not found '/etc/nginx' directory. Please ensure has NGINX installed"
	exit 1
fi

SITES_AVAILABLE="/etc/nginx/sites-available"
SITES_ENABLED="/etc/nginx/sites-enabled"
ROOT_PATH_BASE="/usr/share/nginx/html"
VHOST="/etc/nginx/vhost/site_laravel.conf"

echo -n "Enter the name a domain: "
read DOMAIN

echo -n "Enter the root path for NGINX ($ROOT_PATH_BASE/$DOMAIN/...): "
read ROOT_PATH

echo -n "User page-cache (yes/no): "
read USE_PAGE_CACHE

DOMAIN_PATH="$ROOT_PATH_BASE/$DOMAIN"

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

# Confirm directory exists
if [[ ! -d "$DOMAIN_PATH/$ROOT_PATH" ]]; then
    echo "Creating directory $DOMAIN_PATH/$ROOT_PATH"
	mkdir -p "$DOMAIN_PATH/$ROOT_PATH"
fi

# Change permissions
chown -R dev:dev "$DOMAIN_PATH"

# Create server to domain the on NGINX
echo "server {
    listen 80;
    listen [::]:80;

    server_name $DOMAIN;

    #include /etc/nginx/includes/ssl.conf;
    
    # SSL by Cloudflare
    #ssl_certificate /etc/cloudflare/publkey.pem;
    #ssl_certificate_key /etc/cloudflare/privkey.pem;
    #ssl_client_certificate /etc/cloudflare/origin-pull-ca.pem;

    access_log /var/log/nginx/$DOMAIN.access.log;
    error_log /var/log/nginx/$DOMAIN.error.log;

    root /usr/share/nginx/html/$DOMAIN/$ROOT_PATH;
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
        fastcgi_pass unix:/run/php/php7.4-fpm.sock;
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