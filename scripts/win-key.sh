#!/bin/bash
# Script to extract Windows OEM Product Key from a Windows device 

# Check if user is root
if [[ "${EUID}" -ne 0 ]]
then    
    echo -e "${RED}ERROR: this script needs root privileges for run"
    exit 1
fi

# Check if the device has signs of Windows file systems installed
if [[ -z $(lsblk -fn -o FSTYPE | grep -Ei 'ntfs|fat32') ]]
then
    exit 0
fi

echo -e "${GREEN}"
echo "------------------------------------------"
echo "          WINDOWS OEM PRODUCT KEY         "
echo "------------------------------------------"

# Attempt to recover the product key
echo ""
key=$(strings /sys/firmware/acpi/tables/MSDM | tail -1)
if [[ -z "${key}" ]]
then
    echo -e "${RED}ERROR: unable to extract Windows OEM Product Key"
    echo ""
    exit 1
else
    echo -e "${RED}Extracted OEM Product Key:${NO_COLOUR} ${key}"
    echo ""
fi
