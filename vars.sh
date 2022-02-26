# Configuration file

### [colors] ###
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

USERNAME=dev

HOSTNAME=localhost

ADMIN_EMAIL=duek.digital@gmail.com

# RAM size in MB
#RAM_SIZE=$(dmidecode -t 17 | awk '( /Size/ && $2 ~ /^[0-9]+$/ ) { x+=$2 } END{ print x}')
RAM_SIZE=$(($(getconf _PHYS_PAGES) * $(getconf PAGE_SIZE) / (1024 * 1024)))

### [lemper] ###
# Default Timezone, leave it blank to use default UTC timezone
# or "none" for current server setting.
# Ref: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
# Example: Asia/Jakarta
TIMEZONE=America/Campo_Grande

# It is highly recommended to install PHP version 7.4 or greater.
PHP_VERSION=7.4

# Use NodeJS version.
NODEJS_VERSION=16

### [mysql] ###
# Leave it blank for auto generated secure password.
MYSQL_ROOT_PASS=root
MYSQL_DATABASE_NAME=default
MYSQL_USERNAME=lemper
MYSQL_PASS=lemper
MYSQL_BIND_ADDRESS=127.0.0.1