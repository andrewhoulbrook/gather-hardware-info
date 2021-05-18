# Gathering Device Hardware Info

Small collection of super simple shell scripts to help harvest a range of information about hardware components installed in different machines.

<p align="center">
  <img src="/doc/demo.png">
</p>

## Background

I help run a community initiative seeking to refurbish and reuse old laptops, netbooks, desktops and tablets for local schools and charities. 

I spend a lot of time googling old devices, looking up old eBay listings and screwing devices apart just to find out what's inside them. I wrote these scripts to help speed up the process of gathering information about device components. 

I'm also interested in collecting data about the devices I'm repairing for reuse, using the [Open Repair Data Standard (ORDS)](https://openrepair.org/open-data/open-standard/). This way I can contribute such data to larger initiatives like the [Restart Project](https://therestartproject.org/fixometer-2/) and help to study the impact of community repair and reuse initiatives. 

## Prerequisites

Required utilities are listed in ```requirements.txt```. These will also be installed when ```setup.sh``` is executed.   

I've been running these scripts from a Linux live USB system. I used Ubuntu 18.04 (headless) to build a USB live system with persistent ```/home``` storage using ```mkusb```.

## The Scripts

The scripts below are each called from ```run.sh```.

* ```cpu.sh```
    * Lists basic system info
    * Lists CPU info
    * List BIOS and Chassis info

* ```memory.sh```
    * List info on system memory
    * Lists maximum upgradable memory
    * Checks if any slots available for memory upgrades
    * Runs a quick ```memtester``` check

* ```storage.sh```
    * Lists disk storage info
    * Checks if SMART support exists, runs health check
    * Offers to run additional checks with ```badblocks```
    * Runs ```ioping``` to gather I/O stats for each disk
    
* ```multimedia.sh```
    * Lists display/video cards
    * Lists audio-visual devices

* ```networking.sh```
    * Lists network cards
    * Lists details of network interfaces

* ```win-key.sh```
    * For a Windows machine, attempts to extract OEM Product Key
    * Handy for old machines where the Product Key sticker is missing or unreadable! 

Finally ```peripherals.sh``` simply prints output of ```lspci```, ```lssci``` and ```lsusb``` commands to cover anything possibly missed from scripts above.

## Running the Scripts

Boot to USB live system and simply run ```sudo ./run.sh``` 

A database filename (existing or to be created) must also be passed as an argument when executing ```run.sh```. This is where very basic data about each device is saved, helping me maintain a single dataset about the types of devices passing through my computer repair and reuse initiative. 

User only needs to interact with the dialog before the script itself triggers shutdown. 

## Logging and Data Capture

The scripts will dump all output to a log file as well as stdout. Log file uses ```/etc/machine-id``` and a timestamp for the file name.

A new SQLite database will be created (if one doesn't already exist) to gather basic data required under the ORDS. The unique identifier ```/etc/machine-id``` is used as a ```PRIMARY KEY```. 

```
# Insert ORDS product-related data into tech-recycling database
sqlite3 "${db}" "INSERT INTO devices VALUES (\"${product_id}\", \"${product_cat}\", \"${product_manuf}\", \"${product_model}\", ${manuf_date});" 
```

Data being captured is pretty basic but holds all **Product-related** module data required to comply with ORDS. I can then join separate records maintained for ORDS' **Repair** and **Session** related modules later. 

## Built with

* [Bash](https://www.gnu.org/software/bash/)
* [SQLite](https://sqlite.org/index.html)
* Various Linux utilities (see requirements.txt)

## Computer Repair and Reuse for Schools and Charities

* [My efforts](https://www.facebook.com/Worksop-Techcyclers-107531858058748)
* [Restart Project (UK)](https://therestartproject.org/where-to-donate-your-computer/#tr.row-5.odd)

## Author

Andrew Houlbrook - [andrewhoulbrook](https://github.com/andrewhoulbrook)

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.
