#!/bin/bash
# Script to gather basic information about the CPU and mainboard installed in a machine

# Check if user is root
if [[ "${EUID}" -ne 0 ]]
then    
    echo -e "${RED}ERROR: this script needs root privileges for run"
    exit 1
fi

echo ""
echo -e "${GREEN}------------------------------------------"
echo "          CPU and MAINBOARD               "
echo "------------------------------------------"

# List basic system information
echo ""
echo -e "${RED}Basic system information:${NO_COLOUR}"
echo ""
lshw -C system
echo ""
dmidecode -t system
echo ""

echo -e "${GREEN}"
read -p "Press enter key to continue"

# List BIOS information
echo ""
echo -e "${RED}BIOS information for this machine:${NO_COLOUR}"
echo ""
dmidecode -t bios
echo ""

echo -e "${GREEN}"
read -p "Press enter key to continue"

# List information about the CPU
echo ""
echo -e "${RED}CPU installed in this machine:${NO_COLOUR}"
echo ""
lscpu
echo ""
lshw -C processor
echo ""

echo -e "${GREEN}"
read -p "Press enter key to continue"

# List information about the mainboard and chassis
echo ""
echo -e "${RED}Mainboard installed in this machine:${NO_COLOUR}"
echo ""
dmidecode -t baseboard
echo ""
echo -e "${RED}Chassis type used in this machine:${NO_COLOUR}"
echo ""
dmidecode -t chassis
echo ""
