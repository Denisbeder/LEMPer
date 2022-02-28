#!/usr/bin/env bash

### Create CRONTAB ###
echo -e "${CYAN}[Create CRONTAB]${NC}"

echo "* * * * * www-data cd /usr/share/nginx/html/msinforma.local/core && php artisan schedule:run >> /dev/null 2>&1" >> /etc/crontab