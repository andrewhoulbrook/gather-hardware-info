#!/bin/bash
# Script to setup /home ready to run scripts and store log files

# Install requirements
echo "Installing requirements..."
sudo apt install $(cat requirements.txt | xargs)

# Make sub-directories
echo "Creating sub-directories"
mkdir log db
