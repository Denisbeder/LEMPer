#!/usr/bin/env bash

# https://www.digitalocean.com/community/tutorials/how-to-set-up-an-object-storage-server-using-minio-on-ubuntu-18-04-pt

### Create default account ###
echo -e "${CYAN}[MinIO Server Installation]${NC}"

apt update -yqq

# Download binary file oficial from server Minio
curl -O https://dl.min.io/server/minio/release/linux-amd64/minio

# Make executable the file minio
chmod +x minio

# Move the minio file to /usr/local/bin where the initialization script expect to find it
mv minio /usr/local/bin

# Create the new user to execute minio. Flag -s to set /sbin/nologin as shell to minio-user, this shell not allow login the user. 
useradd -r minio-user -s /sbin/nologin

# Set correct owner to file minio
chown minio-user:minio-user /usr/local/bin/minio

# Now create a directory where storage de files of buckets
mkdir /usr/local/share/minio

# Set the owner to storage buckets directory to minio-user 
chown minio-user:minio-user /usr/local/share/minio

# Create directory of configuration for minio
mkdir /etc/minio

# Set owner to minio config directory
chown minio-user:minio-user /etc/minio

# Create file env to minio
echo 'MINIO_ROOT_USER="minio"
    MINIO_ROOT_PASSWORD="miniostorage"
    MINIO_VOLUMES="/usr/local/share/minio/"
    MINIO_OPTS="-C /etc/minio --address 127.0.0.1:9000"' > /etc/default/minio

echo -e "${CYAN}[Install script of initialization Systemd]${NC}"

# Download file oficial from server Minio
curl -O https://raw.githubusercontent.com/minio/minio-service/master/linux-systemd/minio.service

# Systemd requires unit files to be stored in the systemd configuration directory, so move minio.service there
mv minio.service /etc/systemd/system

# Then run the command to reload all systemd units
systemctl daemon-reload

# Eable Minio to start on boot
systemctl enable minio

# Initialize minio
systemctl start minio

if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
     echo -e "${CYAN}[Don't configure UFW on WSL]${NC}"
else
    # Enable firewall access to the Minio server on the configured port
    ufw allow 9000
fi

# Installation status.
if [[ $(pgrep -c minio) -gt 0 ]]; then
    systemctl restart minio

    echo -e "${GREEN}Minio restarted successfully.${NC}"
elif [[ -n $(command -v minio) ]]; then
    systemctl start minio
    
    if [[ $(pgrep -c minio) -gt 0 ]]; then
        echo -e "${GREEN}Minio started successfully.${NC}"
        systemctl status minio
    else
        echo -e "${RED}Something went wrong with Minio installation.${NC}"
    fi
fi


















