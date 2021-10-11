#!/usr/bin/env bash

### Create default account ###
echo -e "${CYAN}[Create default account in host]${NC}"

adduser $USERNAME

usermod -aG sudo $USERNAME

rsync --archive "--chown=${USERNAME}:${USERNAME}" ~/.ssh "/home/${USERNAME}"

#Disable ssh authentication password
sed -i 's/#\?\(PermitRootLogin\s*\).*$/\1 no/' /etc/ssh/sshd_config
sed -i 's/#\?\(PubkeyAuthentication\s*\).*$/\1 yes/' /etc/ssh/sshd_config
sed -i 's/#\?\(PermitEmptyPasswords\s*\).*$/\1 no/' /etc/ssh/sshd_config
sed -i 's/#\?\(PasswordAuthentication\s*\).*$/\1 no/' /etc/ssh/sshd_config
sed -i 's/#\?\(ChallengeResponseAuthentication\s*\).*$/\1 no/' /etc/ssh/sshd_config

systemctl reload sshd 
