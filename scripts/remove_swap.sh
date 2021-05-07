#!/usr/bin/env bash

### Remove swap ###
echo -e "${CYAN}[Remove swap]${NC}"

SWAP_FILE="/swapfile"

if [ -f ${SWAP_FILE} ]; then
    swapoff ${SWAP_FILE} && \
    sed -i "s|${SWAP_FILE}|#\ ${SWAP_FILE}|g" /etc/fstab && \
    rm -f ${SWAP_FILE}

    echo -e "${GREEN}Swap file removed.${NC}"
else
    echo -e "${YELLOW}Unable to remove swap.${NC}"
fi