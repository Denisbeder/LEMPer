#!/usr/bin/env bash

### Nginx installation ###
echo -e "${CYAN}[Memcached Server Installation]${NC}"

echo -e "${CYAN}Installing Memcached server${NC}"
apt install -yqq \
libevent-dev libsasl2-dev libmemcached-tools libmemcached11 libmemcachedutil2 memcached

# Install PHP Memcached extension.
echo -e "${CYAN}Install PHP Memcached extension${NC}"
apt install -yqq \
"php${PHP_VERSION}-igbinary" "php${PHP_VERSION}-memcache" "php${PHP_VERSION}-memcached" "php${PHP_VERSION}-msgpack"

echo -e "${CYAN}Configuring Memcached server...${NC}"

# Optimizing Memcached conf.
if [[ ${RAM_SIZE} -le 2048 ]]; then
    # If machine RAM less than / equal 2GiB, set Memcached to 1/16 of RAM size.
    MEMCACHED_SIZE=$((RAM_SIZE / 16))
elif [[ ${RAM_SIZE} -gt 2049 && ${RAM_SIZE} -le 8192 ]]; then
    # If machine RAM less than / equal 8GiB and greater than 2GiB, set Memcached to 1/8 of RAM size.
    MEMCACHED_SIZE=$((RAM_SIZE / 8))
else
    # Otherwise, set Memcached to max of 2GiB.
    MEMCACHED_SIZE=2048
fi
# Tweak memcached configuration
sed -i "s/-m 64/-m ${MEMCACHED_SIZE}/g" /etc/memcached.conf
# Disable memcached vulnerability https://thehackernews.com/2018/03/memcached-ddos-exploit-code.html
sed -i "s/^-p 11211/#-p 11211/" /etc/memcached.conf
sed -i "s/^-l 127.4.0.1/#-l 127.4.0.1/" /etc/memcached.conf
# Increase memcached performance by using sockets https://guides.wp-bullet.com/configure-memcached-to-use-unix-socket-speed-boost/
echo -e "-s /tmp/memcached.sock" >> /etc/memcached.conf
echo -e "-a 775" >> /etc/memcached.conf

# Installation status.
if [[ $(pgrep -c memcached) -gt 0 ]]; then
    /etc/init.d/memcached restart

    echo -e "${GREEN}Memcached server restarted successfully.${NC}"
elif [[ -n $(command -v memcached) ]]; then
    /etc/init.d/memcached start
    
    if [[ $(pgrep -c memcached) -gt 0 ]]; then
        echo -e "${GREEN}Memcached server started successfully.${NC}"
    else
        echo -e "${RED}Something went wrong with Memcached installation.${NC}"
    fi
fi