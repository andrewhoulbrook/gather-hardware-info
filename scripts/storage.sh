#!/bin/bash
# Script to gather basic information about hard disks installed in a machine

# Check if user is root
if [[ "${EUID}" -ne 0 ]]
then    
    echo -e "${RED}ERROR: this script needs root privileges for run"
    exit 1
fi

echo ""
echo -e "${GREEN}------------------------------------------"
echo "          SYSTEM HARD DISKS               "
echo "------------------------------------------"

# List characteristics of installed hard disks
echo ""
echo -e "${RED}Storage characteristcs:${NO_COLOUR}"
echo ""
lsblk -f
echo ""

echo -e "${GREEN}"
read -p "Press enter key to continue"

# List disks and partitions as tree structure
echo ""
echo -e "${RED}Tree list of all block devices:${NO_COLOUR}"
echo ""
lsblk
echo ""

echo -e "${GREEN}"
read -p "Press enter key to continue"

# List filesystem information on each disk
echo ""
echo -e "${RED}List of block devices and file systems:${NO_COLOUR}"
echo ""
lsblk -f
echo ""
fdisk -l | egrep -v '/dev/(loop|mapper|md|sr)'
echo ""

echo -e "${GREEN}"
read -p "Press enter key to continue"

disks=$(lsblk -dn -o NAME | egrep -v 'loop|mapper|md|sr')

# I/O performance snapshot for each installed disk
echo ""
echo -e "${RED}Performing quick I/O test of installed disks:${NO_COLOUR}"
echo ""
for disk in "${disks}"
do
    ioping -c 10 "/dev/${disk}"
    echo ""
done

echo -e "${GREEN}"
echo -n "Do you want to scan for bad sectors on installed disks (may take some time depending of the disk size)? [Y|n]"
read sector_scan
echo ""
if [[ "${sector_scan}" == "Y" || "${sector_scan}" == "y" ]]
then
    block_size=$(stat -f ~/.bashrc | grep -i "block size" | cut -d " " -f 3)
    
    # Scan for bad sectors on each disk installed in the machine
    for disk in "${disks}"
    do
        echo -e "${NO_COLOUR}"
        scan=$(badblocks -v -b "${block_size}" "/dev/${disk}")
        echo "${scan}"
        echo ""
        if [[ -n $(echo ${scan} | grep "0 bad blocks found") ]]
        then 
            # Offer to run fsck utility to attempt any quick fixes if bad sectors found
            echo -e "${GREEN}" 
            echo -n "Bad blocks found. Do you want to attempt repair with fsck? [Y|n]"
            read repair
            if [[ "${repair}" == "Y" || "${repair}" == "y" ]]
            then
                echo -e "${NO_COLOUR}"
                echo ""
                fsck -vcck "/dev/${disk}"
            fi
        fi
        echo ""
    done
else
   exit 0
fi

