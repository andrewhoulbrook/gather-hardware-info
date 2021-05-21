
# Script to gather basic information about hard disks installed in a machine

# Check if user is root
if [[ "${EUID}" -ne 0 ]]
then    
    echo -e "${RED}ERROR: this script needs root privileges for run"
    exit 1
fi

echo -e "${GREEN}"
echo "------------------------------------------------------------------------------------"
echo "                              SYSTEM HARD DISKS                                     "
echo "------------------------------------------------------------------------------------"

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
smart_enable_error="false"

# Scan for bad sectors on each disk installed in the machine
for disk in "${disks}"
do
    echo -e "${NO_COLOUR}"
        
    # Check is SMART support is available/enabled
    if [[ -n $(smartctl -i "/dev/${disk}" | grep -i "SMART support is: available") ]]
    then
        if [[ -n $(smartctl -i "/dev/${disk}" | grep -i "SMART support is: disabled") ]]
        then
            # Try to enable SMART
            smartctl -s on "/dev/${disk}"
        
            if [[ $? -eq 0 ]]
            then
                echo "${RED}ERROR: SMART can not be enabled on /dev/${disk}${NO_COLOUR}"
                smart_enable_error="true"
            fi
        fi
        
        if [[ "${smart_enable_error}" == "false" ]]
        then
            # Run SMART health check and self-test
            smartctl -a "/dev/${disk}"
        
            # Output any errors`found
            echo ""
            smartctl -l error -l selftest "/dev/${disk}"
            echo ""
        fi
    fi 

    echo -e "${GREEN}"

    # Offer to run additional scan with badblocks utility
    echo -n "Do you want to scan for bad sectors on installed disks (may take some time depending of the disk size)? [Y|n]"
    read bb_scan
    if [[ "${bb_scan}" == "Y" || "${bb_scan}" == "y" ]]
    then
        echo -e "${NO_COLOUR} "
        block_size=$(stat -f ~/.bashrc | grep -i "block size" | cut -d " " -f 3)
        badblocks -v -b "${block_size}" "/dev/${disk}"
    fi
    echo ""
done

# I/O performance snapshot for each installed disk
echo -e "${RED}Performing quick I/O test of installed disks:${NO_COLOUR}"
echo ""
for disk in "${disks}"
do
    ioping -c 10 "/dev/${disk}"
    echo ""
done
