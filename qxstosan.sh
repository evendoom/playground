#!/bin/bash
# Author: Davide Correia
# Date: 2022/07/11
# This script copies data from QXS_IO_1 to a specified destination on SAN

# Check if all arguments have been supplied

if [[ "${#}" -lt 3 ]]
then
    echo "Usage:"
    echo "qxstosan <project name on QXS_IO_1> <work order number> <full path to destination on SAN>"
    echo "Example:"
    echo "qxstosan sharper 10-12345 /ads/LEXFS1/projects/sharper/editorial"
    exit 1
fi

# Create variables
PROJECT="${1}"
WO_NUMBER="${2}"
DESTINATION="${3}"

# Functions
copy_source() {
    # Open permissions on QXS_IO_1
    sudo chmod -R 777 /ads/QXS_IO_1/io_san/"${PROJECT}"/in/"${WO_NUMBER}"/

    # Copy source to destination
    sudo rsync -ruvPh /ads/QXS_IO_1/io_san/"${PROJECT}"/in/"${WO_NUMBER}"/ "${DESTINATION}"

    # Check if rsync ran successfully
    if [[ "${?}" -ne 0 ]]
    then
        echo "Something went wrong with the rsync. Aborting..."
        exit 1
    fi

    # Rerun rsync
    echo "Tabbing up..."
    sudo rsync -ruvPh /ads/QXS_IO_1/io_san/"${PROJECT}"/in/"${WO_NUMBER}"/ "${DESTINATION}"

    # Open permissions on destination
    echo "Opening permissions on SAN..."
    sudo chmod -R 777 "${DESTINATION}"

    # Check if script ran successfully
    if [[ "${?}" -eq 0 ]]
    then
        echo "Transfer successful!"
    else
        echo "Something went wrong with the transfer, check your Terminal log"
        exit 1
    fi
}

check_status() {
if [[ "${?}" -ne 0 ]]
then
    MESSAGE="${1}"
    echo "${MESSAGE}"
    exit 1
fi
}

# Check if source is accessible
if [[ -d "/ads/QXS_IO_1/io_san/${PROJECT}/in/${WO_NUMBER}" ]]
then
    echo "Source exists!"
else
    check_status "Unable to access source on QXS_IO_1. Aborting..."
fi

# Check if destination exists
if [[ -d "${DESTINATION}" ]]
then
    echo "Destination exists."
else
    echo "Destination does not exist, creating folder structure..."
    sudo mkdir -p "${DESTINATION}"
    sudo chmod -R 777 "${DESTINATION}"
    check_status "Something went wrong creating folder structure on SAN. Check your Terminal log. Aborting..."
fi

copy_source