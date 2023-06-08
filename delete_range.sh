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

# *** Declare variables ***
SRC="${1}"
START="${2}"
END="${3}"

# *** Delete frame range ***
for file in $(seq -f "%08g" "${START}" "${END}")
    do
        rm -vf "${SRC}${file}"*
    done