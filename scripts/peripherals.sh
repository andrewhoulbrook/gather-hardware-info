#!/bin/bash
# Script to gather basic information about various hardware devices (USB, PCI, SCSI etc...) installed in a machine

# Check if user is root
if [[ "${EUID}" -ne 0 ]]
then    
    echo -e "${RED}ERROR: this script needs root privileges for run"
    exit 1
fi

echo -e "${GREEN}"
echo "------------------------------------------------------------------------------------"
echo "                                PERIPHERAL DEVICES                                  "
echo "------------------------------------------------------------------------------------"

# List characteristics of installed SCSI devices
echo ""
echo -e "${RED}SCSI devices installed:${NO_COLOUR}"
echo ""
lsscsi -s | less
echo ""

echo -e "${GREEN}"
read -p "Press enter key to continue"

# List characteristics of installed PCI devices
echo ""
echo -e "${RED}PCI devices installed:${NO_COLOUR}"
echo ""
lspci -v | less
echo ""

echo -e "${GREEN}"
read -p "Press enter key to continue"

# List characteristics of installed USB devices
echo ""
echo -e "${RED}USB devices installed${NO_COLOUR}"
echo ""
lsusb -v | less
echo ""
