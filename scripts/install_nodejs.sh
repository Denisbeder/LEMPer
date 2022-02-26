#!/usr/bin/env bash

### Supervisor installation ###
echo -e "${CYAN}[NodeJS Installation]${NC}"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source $HOME/.bashrc