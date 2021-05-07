#!/usr/bin/env bash

### Fail2ban installation ###
echo -e "${CYAN}[Firewall (UFW)  Installation]${NC}"

# Install UFW
apt install -qq -y ufw

if [[ -n $(command -v ufw) ]]; then
    echo -e "${CYAN}Configuring UFW firewall rules...${NC}"

    # Close all incoming ports.
    ufw default deny incoming

    # Open all outgoing ports.
    ufw default allow outgoing

    # Open SSH port.
    ufw allow "${SSH_PORT}/tcp"

    # Open HTTP port.
    ufw allow 80
    ufw allow 8082 #LEMPer port

    # Open HTTPS port.
    ufw allow 443
    ufw allow 8083 #LEMPer port

    # Open MySQL port.
    #ufw allow 3306

    # Open ntp port : to sync the clock of your machine.
    #ufw allow 123/udp

    # Turn on firewall.
    ufw --force enable

    # Restart
    if /etc/init.d/ufw restart; then
        echo -e "${GREEN}UFW firewall installed successfully.${NC}"
    else
        echo -e "${RED}Something went wrong with UFW installation.${NC}"
    fi
fi