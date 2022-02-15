#!/usr/bin/env bash

### Install dependencies ###
echo -e "${CYAN}Initializing installation...${NC}"
locale-gen pt_BR.UTF-8 && dpkg-reconfigure locales

# Update repositories.
echo -e "${CYAN}Updating repository, please wait...${NC}"
apt update -yqq && apt upgrade -yqq

# Install dependencies.
echo -e "${CYAN}Installing pre-requisites/dependencies package...${NC}"
apt install -yqq \
apt-transport-https apt-utils apache2-utils autoconf automake bash build-essential ca-certificates cmake cron \
curl dnsutils gcc geoip-bin geoip-database git gnupg2 htop iptables libc6-dev libcurl4-openssl-dev libgd-dev libgeoip-dev \
libssl-dev libxml2-dev libpcre3-dev libtool libxslt1-dev lsb-release make openssh-server openssl pkg-config \
python python3 re2c rsync software-properties-common sasl2-bin snmp sudo sysstat tar tzdata unzip wget whois zlib1g-dev mariadb-client

# Configure server clock.
echo -e "${CYAN}Reconfigure server clock to: ${TIMEZONE}...${NC}"
bash -c "echo '${TIMEZONE}' > /etc/timezone"
rm -f /etc/localtime

echo -e "${GREEN}Required packages installation completed...${NC}"

# Autoremove unused packages.
echo -e "${CYAN}Cleaning up unused packages...${NC}"
apt autoremove -yqq