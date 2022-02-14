#!/usr/bin/env bash

### Nginx installation ###
echo -e "${CYAN}[PHP & FPM Packages Installation]${NC}"

PHPv=$PHP_VERSION

# Install PHP-FPM stack
PHP_PKGS=("
php${PHPv}
php${PHPv}-bcmath
php${PHPv}-bz2
php${PHPv}-calendar
php${PHPv}-cli
php${PHPv}-common
php${PHPv}-curl
php${PHPv}-dev
php${PHPv}-exif
php${PHPv}-fileinfo
php${PHPv}-fpm
php${PHPv}-gd
php${PHPv}-gettext
php${PHPv}-gmp
php${PHPv}-iconv
php${PHPv}-imagick
php${PHPv}-imap
php${PHPv}-intl
php${PHPv}-mbstring
php${PHPv}-mysql
php${PHPv}-opcache
php${PHPv}-pdo
php${PHPv}-posix
php${PHPv}-pspell
php${PHPv}-readline
php${PHPv}-ldap
php${PHPv}-snmp
php${PHPv}-soap
php${PHPv}-sqlite3
php${PHPv}-tidy
php${PHPv}-tokenizer
php${PHPv}-xml
php${PHPv}-xmlrpc
php${PHPv}-xsl
php${PHPv}-zip
php-pear
php-xml
pkg-php-tools
spawn-fcgi fcgiwrap
")

# Install the repository ppa:ondrej/php, which will give you all your versions of PHP
apt install -yqq language-pack-en-base
export LC_ALL=en_US.UTF-8 
export LANG=en_US.UTF-8 
apt install -yqq software-properties-common
add-apt-repositoyry ppa:ondrej/php5
apt-update

apt install -yqq ${PHP_PKGS[@]}

apt -yqq autoremove

##
# PHP & FPM Optimization.
#
echo -e "${CYAN}Optimizing PHP ${PHPv} & FPM configuration...${NC}"

# Copy the optimized-version of php.ini
mv "/etc/php/${PHPv}/fpm/php.ini" "/etc/php/${PHPv}/fpm/php.ini~"
cp -f "etc/php/${PHPv}/fpm/php.ini" "/etc/php/${PHPv}/fpm/"

# Copy the optimized-version of php-fpm config file.
mv "/etc/php/${PHPv}/fpm/php-fpm.conf" "/etc/php/${PHPv}/fpm/php-fpm.conf~"
cp -f "etc/php/${PHPv}/fpm/php-fpm.conf" "/etc/php/${PHPv}/fpm/"

# Copy the optimized-version of php fpm default pool.
mv "/etc/php/${PHPv}/fpm/pool.d/www.conf" "/etc/php/${PHPv}/fpm/pool.d/www.conf~"
cp -f "etc/php/${PHPv}/fpm/pool.d/www.conf" "/etc/php/${PHPv}/fpm/pool.d/"

# Update timezone.
sed -i "s|php_admin_value\[date\.timezone\]\ =\ UTC|php_admin_value\[date\.timezone\]\ =\ ${TIMEZONE}|g" \
    "/etc/php/${PHPv}/fpm/pool.d/www.conf"

# Create default directories for php optimized.
mkdir -p "/usr/share/nginx/html/.lemper/tmp"
mkdir -p "/usr/share/nginx/html/.lemper/php/opcache"
mkdir -p "/usr/share/nginx/html/.lemper/php/sessions"
mkdir -p "/usr/share/nginx/html/cgi-bin"
chown -hR "${USERNAME}:${USERNAME}" "/home/${USERNAME}"

# Create PHP log dir.
if [ ! -d /var/log/php ]; then
    mkdir -p /var/log/php
fi

# Restart PHP-fpm server.
if [[ $(pgrep -c "php-fpm${PHPv}") -gt 0 ]]; then
    /etc/init.d/"php${PHPv}-fpm" reload
    echo -e "${GREEN}php${PHPv}-fpm reloaded successfully.${NC}"
elif [[ -n $(command -v "php${PHPv}") ]]; then
    /etc/init.d/"php${PHPv}-fpm" start

    if [[ $(pgrep -c "php-fpm${PHPv}") -gt 0 ]]; then
        echo -e "${GREEN}php${PHPv}-fpm started successfully.${NC}"
    else
        echo -e "${RED}Something goes wrong with PHP ${PHPv} & FPM installation.${NC}"
    fi
fi