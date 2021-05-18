#!/bin/bash
# Script to gather basic information about hardware display/graphics controllers and audio-visual devices installed in a machine

# Check if user is root
if [[ "${EUID}" -ne 0 ]]
then    
    echo -e "${RED}ERROR: this script needs root privileges for run"
    exit 1
fi

echo -e "${GREEN}"
echo "------------------------------------------------------------------------------------"
echo "                           SYSTEM VIDEO/AUDIO DEVICES                               "
echo "------------------------------------------------------------------------------------"

# List characteristics of installed display/video modules
echo ""
echo -e "${RED}Installed display/video controllers:${NO_COLOUR}"
echo ""
lshw -C display
echo ""

echo -e "${GREEN}"
read -p "Press enter key to continue"

# List characteristics of installed audio-visual devices
echo ""
echo -e "${RED}Installed audio-visual devices:${NO_COLOUR}"
echo ""
lshw -C multimedia
echo ""
