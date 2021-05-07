#!/usr/bin/env bash

### Check and enable swap ###
echo -e "${CYAN}[Check and enable swap]${NC}"

SWAP_FILE="/swapfile"
if [[ ${RAM_SIZE} -le 2048 ]]; then
    # If machine RAM less than / equal 2GiB, set swap to 2x of RAM size.
    SWAP_SIZE=$((RAM_SIZE * 2))
elif [[ ${RAM_SIZE} -gt 2048 && ${RAM_SIZE} -le 8192 ]]; then
    # If machine RAM less than / equal 8GiB and greater than 2GiB, set swap equal to RAM size.
    SWAP_SIZE="${RAM_SIZE}"
else
    # Otherwise, set swap to max of 8GiB.
    SWAP_SIZE=8192
fi

echo -e "${CYAN}Creating ${SWAP_SIZE}MiB swap...${NC}"

# Create swap.
fallocate -l "${SWAP_SIZE}M" ${SWAP_FILE} && \
chmod 600 ${SWAP_FILE} && \
chown root:root ${SWAP_FILE} && \
mkswap ${SWAP_FILE} && \
swapon ${SWAP_FILE}

# Make the change permanent.
if grep -qwE "#${SWAP_FILE}" /etc/fstab; then
    sed -i "s|#${SWAP_FILE}|${SWAP_FILE}|g" /etc/fstab
else
    echo "${SWAP_FILE} swap swap defaults 0 0" >> /etc/fstab
fi


# Adjust swappiness, default Ubuntu set to 60
# meaning that the swap file will be used fairly often if the memory usage is
# around half RAM, for production servers you may need to set a lower value.
if [[ $(cat /proc/sys/vm/swappiness) -gt 10 ]]; then
    sysctl vm.swappiness=10
    echo "vm.swappiness=10" >> /etc/sysctl.conf
fi