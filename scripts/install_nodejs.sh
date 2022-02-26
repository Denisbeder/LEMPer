#!/usr/bin/env bash

### NodeJS installation ###
echo -e "${CYAN}[NodeJS Installation]${NC}"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source $HOME/.bashrc
nvm install --lts
nvm install node