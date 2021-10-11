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

apt install -qq -y ${PHP_PKGS[@]}

apt -qq -y autoremove

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
run mkdir -p "/home/${POOLNAME}/.lemper/tmp"
run mkdir -p "/home/${POOLNAME}/.lemper/php/opcache"
run mkdir -p "/home/${POOLNAME}/.lemper/php/sessions"
run mkdir -p "/home/${POOLNAME}/cgi-bin"
run chown -hR "${POOLNAME}:${POOLNAME}" "/home/${POOLNAME}"

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