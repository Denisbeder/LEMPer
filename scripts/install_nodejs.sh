#!/usr/bin/env bash

### Supervisor installation ###
echo -e "${CYAN}[NodeJS Installation]${NC}"

# Install the NodeJS
curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | bash -
apt update && apt install -yqq nodejs

# Install the Yarn package manager
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt update && apt install -yqq yarn 

apt autoremove -yqq