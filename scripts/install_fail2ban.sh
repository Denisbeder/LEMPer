#!/usr/bin/env bash

### Fail2ban installation ###
echo -e "${CYAN}[Fail2ban Installation]${NC}"

apt install -yqq fail2ban

SSH_PORT=22

# Enable jail
cat > /etc/fail2ban/jail.local <<_EOL_
[DEFAULT]
# banned for 30 days
bantime = 30d

# ignored ip (googlebot) - https://ipinfo.io/AS15169
ignoreip = 66.249.64.0/19 66.249.64.0/20 66.249.80.0/22 66.249.84.0/23 66.249.88.0/24

[sshd]
enabled = true
port = ssh,${SSH_PORT}
filter = sshd
logpath = /var/log/auth.log
maxretry = 3

[nginx-http-auth]
enabled = true
port    = http,https,8082,8083
maxretry = 3

_EOL_

systemctl start fail2ban