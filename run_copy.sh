#!/bin/bash

# Author: Davide Correia
# Date: 2022/06/29
# This script copies data from SAN onto QXS_IO_1. It verifies if the source location is valid, copies it to QXS_IO_1 and then opens permissions on QXS_IO_1.

# Check if script is being executed with sudo
if [[ "${UID}" -ne 0 ]]
then
    echo "You need to run this script with sudo or as root"
    exit 1
fi

# Create variables
SOURCE="${1}"
PROJECT="${2}"
WO="${3}"
CONTAINER=$(basename "${SOURCE}")
IS_FOLDER='true'

# Create functions
# This function copies from SAN to QXS_IO_1
copy_source() {

    # Open permissions on source
    echo "Opening permissions on source..."
    chmod -R 777 "${SOURCE}"

    # Copy from source to QXS_IO_1
    if [[ "${IS_FOLDER}" = 'true' ]]
    then
        rsync -ruvPh "${SOURCE}" ads/QXS_IO_1/io_san/"${PROJECT}"/out/"${WO}"/"${CONTAINER}"/
    else
        rsync -ruvPh "${SOURCE}" ads/QXS_IO_1/io_san/"${PROJECT}"/out/"${WO}"/
    fi

    # Check if rsync was successful
    if [[ "${?}" -ne 0 ]]
    then
        echo "Something went wrong with your rsync. Check your Terminal!"
        return 1
    fi

    # Rerun rsync
    echo "Tabbing up..."
    if [[ "${IS_FOLDER}" = 'true' ]]
    then
        rsync -ruvPh "${SOURCE}" ads/QXS_IO_1/io_san/"${PROJECT}"/out/"${WO}"/"${CONTAINER}"/
    else
        rsync -ruvPh "${SOURCE}" ads/QXS_IO_1/io_san/"${PROJECT}"/out/"${WO}"/
    fi

    # Open permissions on QXS_IO_1
    echo
    echo "Opening permissions on QXS_IO_1..."
    chmod -R 777 ads/QXS_IO_1/io_san/"${PROJECT}"/out/"${WO}"/

    # Check status
    if [[ "${?}" -eq 0 ]]
    then
        echo
        echo "All fine and dandy!"
    else
        echo
        echo "Something went wrong, check your Terminal!"
        return 1
    fi
}

# Check if QXS_IO_1 exists
if [[ -d "ads/QXS_IO_1/" ]]
then
    echo "QXS_IO_1 exists!"
else
    echo "Unable to access QXS_IO_1. Aborting..."
    exit 1
fi

# Check if source exists
if [[ -d "${SOURCE}" ]]
then
    echo "Source is a directory"
elif [[ -f "${SOURCE}" ]]
then
    echo "Source is a file"
    IS_FOLDER='false'
else
    echo "Source doesn't exist, aborting..."
    exit 1
fi

# Setup folder structure
if [[ -d  "ads/QXS_IO_1/io_san/${PROJECT}/out/" ]]
then
    echo "Project on QXS_IO_1 exists. Creating WO container..."
    mkdir -p ads/QXS_IO_1/io_san/"${PROJECT}"/out/"${WO}"/
    copy_source
else
    echo "Project on QXS_IO_1 doesn't exist, creating folder structure..."
    mkdir -p ads/QXS_IO_1/io_san/"${PROJECT}"/out/"${WO}"/
    copy_source
fi