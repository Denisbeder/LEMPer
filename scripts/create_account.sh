#!/usr/bin/env bash

### Create default account ###
echo -e "${CYAN}[Create default account in host]${NC}"

adduser $USERNAME

usermod -aG sudo $USERNAME
adduser $USERNAME www-data

rsync --archive "--chown=${USERNAME}:${USERNAME}" ~/.ssh "/home/${USERNAME}"
