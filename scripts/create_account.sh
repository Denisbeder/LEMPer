#!/usr/bin/env bash

### Create default account ###
echo -e "${CYAN}[Create default account in host]${NC}"

USERNAME=dev

adduser $USERNAME

usermod -aG sudo $USERNAME

rsync --archive "--chown=${USERNAME}:${$USERNAME}" ~/.ssh "/home/${USERNAME}"