#!/usr/bin/env bash

### Nginx installation ###
echo -e "${CYAN}[Nginx HTTP (Web) Server Installation]${NC}"

# Delete previous Nginx installation
apt-get purge nginx-core nginx-common nginx -yqq && apt-get autoremove -yqq

# Update list of available packages
apt-get update -yqq

# Install custom Nginx package
apt-get install nginx mariadb-client -yqq

echo -e "${CYAN}Creating Nginx configuration...${NC}"

# Copy custom Nginx Config.
if [ -f /etc/nginx/nginx.conf ]; then
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf~
fi

cp -f etc/nginx/nginx.conf /etc/nginx/
cp -f etc/nginx/charset /etc/nginx/
cp -f etc/nginx/comp_gzip /etc/nginx/
cp -f etc/nginx/{fastcgi_https_map,fastcgi_params,proxy_params} \
    /etc/nginx/
cp -f etc/nginx/{http_cloudflare_ips,http_proxy_ips,upstream} /etc/nginx/
cp -fr etc/nginx/{includes,vhost} /etc/nginx/

if [ -f /etc/nginx/sites-available/default ]; then
    mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default~
fi
cp -f etc/nginx/sites-available/default /etc/nginx/sites-available/

# Enable default virtual host (mandatory).
if [ -f /etc/nginx/sites-enabled/default ]; then
    unlink /etc/nginx/sites-enabled/default
fi
if [ -f /etc/nginx/sites-enabled/00-default ]; then
    unlink /etc/nginx/sites-enabled/00-default
fi
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/00-default

# Custom pages.
if [ ! -d /usr/share/nginx/html ]; then
    mkdir -p /usr/share/nginx/html
fi

# Custom errors pages.
#cp -fr share/nginx/html/error-pages /usr/share/nginx/html/

mkdir -p /usr/share/nginx/html/site/public
cp -f share/nginx/html/index.html /usr/share/nginx/html/site/public/

# Remove index.html default NGINX
rm -f /usr/share/nginx/html/index.html 

# Fix ownership.
chown -R ${USERNAME}:${USERNAME} /usr/share/nginx/html

# Adjust nginx to meet hardware resources.
echo -e "${CYAN}Adjust nginx to meet hardware resources...${NC}"

set CPU_CORES && \
CPU_CORES=$(grep -c processor /proc/cpuinfo)

set NGX_CONNECTIONS
case ${CPU_CORES} in
    1)
        NGX_CONNECTIONS=1024
    ;;
    2|3)
        NGX_CONNECTIONS=2048
    ;;
    *)
        NGX_CONNECTIONS=4096
    ;;
esac

# Adjust worker processes.
sed -i "s/worker_processes\ auto/worker_processes\ ${CPU_CORES}/g" /etc/nginx/nginx.conf

# Adjust worker connections.
sed -i "s/worker_connections\ 4096/worker_connections\ ${NGX_CONNECTIONS}/g" /etc/nginx/nginx.conf

# Make default server accessible from hostname or IP address.
sed -i "s/localhost.localdomain/${HOSTNAME}/g" /etc/nginx/sites-available/default

# Restart Nginx server
echo -e "${CYAN}Starting Nginx HTTP server...${NC}"

if [[ $(pgrep -c nginx) -gt 0 ]]; then
    if nginx -t 2>/dev/null > /dev/null; then
        /etc/init.d/nginx reload
        echo -e "${GREEN}Nginx HTTP server restarted successfully.${NC}"
    else
        echo -e "${RED}Nginx configuration test failed. Please correct the error below:${NC}"
        nginx -t
    fi
elif [[ -n $(command -v nginx) ]]; then
    if nginx -t 2>/dev/null > /dev/null; then
        /etc/init.d/nginx start

        if [[ $(pgrep -c nginx) -gt 0 ]]; then
            echo -e "${GREEN}Nginx HTTP server started successfully.${NC}"
        else
            echo -e "${RED}Something went wrong with Nginx installation.${NC}"
        fi
    else
        echo -e "${RED}Nginx configuration test failed. Please correct the error below:${NC}"
        nginx -t
    fi
fi