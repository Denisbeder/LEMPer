#!/usr/bin/env bash

### Install dependencies ###
echo -e "${CYAN}[Certbot Let's Encrypt Installation]${NC}"

add-apt-repository -y ppa:certbot/certbot
apt update -yqq
apt install -yqq certbot

# Add Certbot auto renew command to cronjob.
export EDITOR=nano
CRONCMD='15 3 * * * /usr/bin/certbot renew --quiet --renew-hook "/usr/sbin/service nginx reload -s"'
touch lemper.cron
crontab -u root lemper.cron
crontab -l > lemper.cron

if ! grep -qwE "/usr/bin/certbot\ renew" lemper.cron; then

cat >> lemper.cron <<EOL
# LEMPer Cronjob
# Certbot Auto-renew Let's Encrypt certificates
#SHELL=/bin/sh
#PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

${CRONCMD}
EOL

crontab lemper.cron
rm -f lemper.cron
fi

# Register a new account.
local LE_EMAIL=${ADMIN_EMAIL:-"cert@email"}

if [ -d /etc/letsencrypt/accounts/acme-v02.api.letsencrypt.org/directory ]; then
    certbot update_account --email "${LE_EMAIL}" --no-eff-email --agree-tos
else
    certbot register --email "${LE_EMAIL}" --no-eff-email --agree-tos
fi

if certbot --version | grep -q "certbot"; then
    echo -e "${GREEN}Certbot successfully installed.${NC}"
else
    echo -e "${GREEN}Something went wrong with Certbot installation.${NC}"
fi