#!/bin/bash
# Run shell scripts to gather and report device info

# Set console display colours
export RED='\033[0;31m'
export GREEN='\033[1;32m'
export NO_COLOUR='\033[0m'

# Output files for logging device info (raw output and ORDS compliant data)
log="log/device_info.log"
db="db/${1}"

# Check filepath provided for sqlite database to store repair data
if [[ -z "${1}" ]]
then
    echo -e "${RED}ERROR: re-run this script providing a file path for repair database, e.g. sudo ./run.sh myrepairs.sqlite"
    exit 1
fi

# Check if sqlite db exists to store repair data
if [[ ! -e "${db}" ]]
then
    echo ""
    echo -e "${GREEN}Creating ${db} database..."
    ./scripts/create-ords-db.sh "${db}"
    echo ""
    if [[ $? -ne 0 ]]
    then
        echo -e "${RED}ERROR: unable to create new sqlite database."
        exit 1
    fi
fi

# Print ASCII art banner to console
echo -e "${GREEN} "
figlet -c -k "DEVICE INFO"
figlet -c -k -f digital "Worksop Techcyclers"

# Check if user is root
if [[ "${EUID}" -ne 0 ]]
then    
    echo -e "${RED}ERROR: this script needs root privileges for run"
    exit 1
fi

# Run shell scripts to gather and report device info
./scripts/win-key.sh | tee "${log}" || {
    echo -e "${RED}ERROR: error gathering information about CPU and mainboard" 1>&2
    exit 1
}
echo -e "${GREEN}"
read -p "Press enter key to continue"

./scripts/cpu.sh | tee -a "${log}" || {
    echo -e "${RED}ERROR: error gathering information about CPU and mainboard" 1>&2
    exit 1
}
echo -e "${GREEN}"
read -p "Press enter key to continue"

./scripts/memory.sh | tee -a "${log}" || {
    echo -e "${RED}ERROR: error gathering information about system memory" 1>&2
    exit 1
}
echo -e "${GREEN}"
read -p "Press enter key to continue"

./scripts/storage.sh | tee -a "${log}" || {
    echo -e "${RED}ERROR: error gathering information about system storage devices" 1>&2
    exit 1
}
echo -e "${GREEN}"
read -p "Press enter key to continue"

./scripts/multimedia.sh | tee -a "${log}" || {
    echo -e "${RED}ERROR: error gathering information about mulimedia devices" 1>&2
    exit 1
}
echo -e "${GREEN}"
read -p "Press enter key to continue"

./scripts/networking.sh | tee -a "${log}" || {
    echo -e "${RED}ERROR: error gathering information about networking devices" 1>&2
    exit 1
}
echo -e "${GREEN}"
read -p "Press enter key to continue"
echo ""
echo -e "${RED}Printing additional useful information${NO_COLOUR}"
./scripts/peripherals.sh | tee -a "${log}" || {
    echo -e "${RED}ERROR: error gathering additioanl information about PCI, USB and SCSI devices" 1>&2
    exit 1
}

# Finalise loggin and ORDS data files, then trigger system shutown
echo -e "${GREEN}"
echo "Finished gathering and reporting device information"

# Get ORDS product-related data and append to ORDS csv file
product_id="$(cat /etc/machine-id)"
product_cat="$(cat "${log}" | grep -i "chassis=" | xargs | cut -d " " -f 2 | cut -d "=" -f 2 | tr '[:upper:]' '[:lower:]' | tr -d " ")"

if [[ "${product_cat}" == "notebook" || "${product_cat}" == "laptop" || "${product_cat}" == "netbook" || "${product_cat}" == "macbook" ]]
then
    product_cat="Laptop"
else
    product_cat="Desktop Computer"
fi

product_manuf="$(cat "${log}" | grep -i "manufacturer:" | head -n 1 | cut -d ":" -f 2 | awk '{$1=$1};1')"
product_model="$(cat "${log}" | grep -i "product name:" | head -n 1 | cut -d ":" -f 2 | awk '{$1=$1};1')"
manuf_date="$(cat "${log}" | grep -i "release date:" | head -n 1 | cut -d ":" -f 2 | cut -d "/" -f 3 | awk '{$1=$1};1')"

# Check if device is already recorded in ORDS repair database
if [[ "$(sqlite3 "${db}" "SELECT EXISTS(SELECT id FROM devices WHERE id=\"${product_id}\")";)" -eq 0 ]]
then
    # Insert ORDS repair data into sqlite database
    sqlite3 "${db}" "INSERT INTO devices VALUES (\"${product_id}\", \"${product_cat}\", \"${product_manuf}\", \"${product_model}\", ${manuf_date});" 
fi

echo ""
echo "Device information has been stored in log/${product_id}-$(date +%s).log"

# Renamee log file with device name and timestamp
mv "${log}" "log/${product_id}-$(date +%s).log"

echo ""
echo "Open Repair Data for this device has been stored in database ${db}"
echo ""
echo -e "${RED}Ready to shutdown${GREEN}"
echo ""
read -p "Press enter key to initiate system shutdown"
echo ""
figlet -c -k "Goodbye!"
shutdown now
