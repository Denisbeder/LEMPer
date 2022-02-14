#!/usr/bin/env bash

### Supervisor installation ###
echo -e "${CYAN}[Supervisor Installation]${NC}"

# Install the supervisor
apt install -yqq supervisor && apt -yqq autoremove

echo -e "${CYAN}Optimizing Supervisor...${NC}"

# Modify the ./supervisor.conf file to match your App's requirements.
cp -f "etc/supervisor/laravel-worker.conf" "/etc/supervisor/conf.d/laravel-worker.conf"

echo -e "${CYAN}Start Supervisor...${NC}"
/etc/init.d/supervisor start
/etc/init.d/supervisor reread
/etc/init.d/supervisor update
/etc/init.d/supervisor start laravel-worker:*