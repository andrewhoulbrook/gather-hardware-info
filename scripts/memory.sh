#!/bin/bash
# Script to gather basic information about hardware memory modules installed in a machine

# Check if user is root
if [[ "${EUID}" -ne 0 ]]
then    
    echo -e "${RED}ERROR: this script needs root privileges for run"
    exit 1
fi

echo ""
echo -e "${GREEN}------------------------------------------"
echo "          SYSTEM MEMORY                   "
echo "------------------------------------------"

# List characteristics of installed memory modules
echo ""
echo -e "${RED}Memory characteristcs:${NO_COLOUR}"
echo ""
lshw -short -C memory
echo ""

# List maximum allowable memory for upgrades
echo ""
echo -e "${RED}Maximum allowable memory is:${NO_COLOUR} $(dmidecode -t memory | grep -i max)"
echo ""

# List currently available open memory slots
if [[ -n $(lshw -short -C memory | grep -i empty) ]] 
then
    echo ""
    echo -e "${RED}There following memory slot is available and unused:${NO_COLOUR} $(lshw -short -C memory | grep -i empty)"
    echo ""
else
    echo ""
    echo -e "${RED}All memory slots are used. There are NO empty memory slots available"
    echo ""
fi

echo -e "${GREEN}"
read -p "Press enter key to continue"

# Perform memory stress test using memtester over a 128 MB block of memory
echo ""
echo -e "${RED}Performing quick test to find any memory faults:${NO_COLOUR}"
echo ""
memtester 128 3
if [[ $? -ne 0 ]]
then
    echo -e "${RED}Error found during test. Possible memory fault."
fi
echo ""
