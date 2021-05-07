# Configuration file

### [colors] ###
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

ADMIN_EMAIL=duek.digital@gmail.com

# RAM size in MB
#RAM_SIZE=$(dmidecode -t 17 | awk '( /Size/ && $2 ~ /^[0-9]+$/ ) { x+=$2 } END{ print x}')
RAM_SIZE=$(($(getconf _PHYS_PAGES) * $(getconf PAGE_SIZE) / (1024 * 1024)))

### [lemper] ###
# Server hostname must be valid FQDN format, leave it blank for system default.
SERVER_HOSTNAME="test.com"

# Server IP address, leave it blank for auto detection.
SERVER_IP=""

# Default account username.
LEMPER_USERNAME="lemper"

# Password for default lemper account,
# leave it blank for auto generated secure password.
LEMPER_PASSWORD=""

# Default Timezone, leave it blank to use default UTC timezone
# or "none" for current server setting.
# Ref: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
# Example: Asia/Jakarta
TIMEZONE="America/Campo_Grande"

### [ssh] ###
# Customized SSH port.
SSH_PORT=2269

# Allow SSH root login (value: true | false).
SSH_ROOT_LOGIN=false

# Password-less SSH, login with key (value: true | false).
SSH_PASSWORDLESS=false

# Your RSA Public key.
RSA_PUB_KEY="copy_your_ssh_public_rsa_key_here"

# Hash length (bits), supported value 2048 | 4096 (take too long times)
# length of bits used for generating RSA key / Diffie-Helman params.
HASH_LENGTH=2048

# It is highly recommended to install PHP version 7.4 or greater.
PHP_VERSION="7.4"

### [mysql] ###
# Leave it blank for auto generated secure password.
MYSQL_ROOT_PASS=""

# MariaDB backup user.
MARIABACKUP_USER="lemperdb"

# Leave it blank for auto generated secure password.
MARIABACKUP_PASS=""