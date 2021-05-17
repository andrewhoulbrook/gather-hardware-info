#!/bin/bash
# Script to gather basic information about hardware networking devices installed in a machine

# Check if user is root
if [[ "${EUID}" -ne 0 ]]
then    
    echo -e "${RED}ERROR: this script needs root privileges for run"
    exit 1
fi

echo ""
echo -e "${GREEN}------------------------------------------"
echo "          NETWORKING DEVICES              "
echo "------------------------------------------"

# List characteristics of installed networking devices
echo ""
echo -e "${RED}Networking devices:${NO_COLOUR}"
echo ""
lshw -C network
echo ""

# Show basic network interface details
echo ""
echo -e "${RED}Basic network interface details:${NO_COLOUR}"
echo ""
ip link show
#ifconfig -a
echo ""
