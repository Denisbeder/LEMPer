#!/usr/bin/env bash

### Nginx installation ###
echo -e "${CYAN}[Redis Server Installation]${NC}"

apt install -yqq redis-server redis-tools

echo -e "${CYAN}Configuring Memcached server...${NC}"

# Configure Redis.
cp -f etc/redis/redis.conf /etc/redis/

# This directive allows you to declare an init system to manage Redis as a service, giving you more control over an operation of your operation
sed -i "s/^supervised no/supervised systemd/" /etc/redis/redis.conf

# Custom Redis configuration.
if [[ ${RAM_SIZE} -le 2048 ]]; then
    # If machine RAM less than / equal 2GiB, set Memcached to 1/16 of RAM size.
    REDISMEM_SIZE=$((RAM_SIZE / 16))
elif [[ ${RAM_SIZE} -gt 2049 && ${RAM_SIZE} -le 8192 ]]; then
    # If machine RAM less than / equal 8GiB and greater than 2GiB, set Memcached to 1/8 of RAM size.
    REDISMEM_SIZE=$((RAM_SIZE / 8))
else
    # Otherwise, set Memcached to max of 2GiB.
    REDISMEM_SIZE=2048
fi

# Optimize Redis config.
cat >> /etc/redis/redis.conf <<EOL

####################################
# Custom configuration for LEMPer
#
maxmemory ${REDISMEM_SIZE}mb
maxmemory-policy allkeys-lru
EOL

# Custom kernel optimization for Redis.
cat >> /etc/sysctl.conf <<EOL

###################################
# Custom optimization for LEMPer
#
net.core.somaxconn=65535
vm.overcommit_memory=1
EOL

if [ ! -f /etc/rc.local ]; then
    touch /etc/rc.local
fi

# Make the change persistent.
cat >> /etc/rc.local <<EOL

###################################################################
# Custom optimization for LEMPer
#
sysctl -w net.core.somaxconn=65535
echo never > /sys/kernel/mm/transparent_hugepage/enabled
EOL

# Init Redis script.
if [ ! -f /etc/init.d/redis-server ]; then
    cp -f etc/init.d/redis-server /etc/init.d/
    chmod ugo+x /etc/init.d/redis-server
fi

echo -e "${CYAN}Starting Redis server...${NC}"

# Restart Redis daemon.
/etc/init.d/redis-server restart

if [[ $(pgrep -c redis-server) -gt 0 ]]; then
    echo -e "${GREEN}Redis server started successfully.${NC}"
else
    echo -e "${RED}Something went wrong with Redis installation.${NC}"
fi