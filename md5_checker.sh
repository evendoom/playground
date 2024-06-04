#!/bin/bash
# Author: Davide Correia
# Date: 2024/06/04
# Description: This script parses an MD5 file, generates a new checksum from the path on MD5 file
# and cross checks it against the checksum generated originally. Great for Mac systems without md5sum installed
# Usage: md5_checker.sh <name of MD5 file> 

SOURCE="${1}"
FAILED_CHECKS=0
readarray -t CHECKSUM_LIST <<< $(cat "${SOURCE}")
for item in "${!CHECKSUM_LIST[@]}"
    do
        ITEM_CHECKSUM=$(echo "${CHECKSUM_LIST[item]}" | awk '{print $1}')
        ITEM_PATH=$(echo "${CHECKSUM_LIST[item]}" | awk '{print $2}')
        DISK_MD5=$(md5sum "$ITEM_PATH" | awk '{print $1}')
        
        if [[ "${ITEM_CHECKSUM}" = "${DISK_MD5}" ]]
            then
                echo "${ITEM_PATH}: OK"
            else
                echo "${ITEM_PATH}: FAILED"
                FAILED_CHECKS=$((FAILED_CHECKS+1))
        fi
    done

echo "${SOURCE} check complete. ${FAILED_CHECKS} files failed verification."