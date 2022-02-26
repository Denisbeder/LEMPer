#!/usr/bin/env bash

### Supervisor installation ###
echo -e "${CYAN}[NodeJS Installation]${NC}"

# Install the NodeJS
curl -sL "https://deb.nodesource.com/setup_${NODEJS_VERSION}.x" -o nodesource_setup.sh
bash nodesource_setup.sh
apt update && apt install nodejs

# Install the Yarn package manager
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt update && apt install yarn 

apt autoremove -yqq

# delete 
rm -f nodesource_setup.sh