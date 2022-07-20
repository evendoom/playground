#!/bin/bash

# Author: Davide Correia
# Date: 2022/07/11
# This script deletes a specific frame range from an image sequence

# Check if all arguments have been supplied
if [[ "${#}" -lt 3 ]]
then
    echo "Usage:"
    echo "delete_range <full destination path on SAN, including filename up to padding> <start frame> <end frame>"
    echo "Example:"
    echo "delete_range /ads/LX_VOL_0/projects/my_project/1920x1080/my_project_files. 0000000 0000100"
    echo "The above example deletes frames 0000000 to 0000100 (101 frames)"
    exit 1
fi

# Declare variables
PATH="${1}"
START="${2}"
END="${3}"
SOURCE_DIRECTORY=""

# Declare functions
# Create source directory from PATH
source() {
    IFS='/' read -r -a temp_array <<< "${PATH}"

    MAX_ARRAY_NUMBER=$(/usr/bin/expr "${#temp_array[@]}" - 1)
    for el in "${temp_array[@]}"
    do
        if [[ "${el}" != "${temp_array[${MAX_ARRAY_NUMBER}]}" ]]
        then
            SOURCE_DIRECTORY+="${el}/"
        fi
    done 
}

# Chmod source
chmod_source() {
    if [[ -d "${SOURCE_DIRECTORY}" ]]
    then
        sudo chmod -R 777 "${SOURCE_DIRECTORY}"
    else
        check_status "Couldn't find source folder."
    fi
}

# Kill script if exit status -ne 0
check_status() {
    if [[ "${?}" -ne 0 ]]
    then
        MESSAGE="${1}"
        echo "${MESSAGE}"
        echo "Aborting..."
        exit 1
    fi
}

# Script runs here...
source
chmod_source